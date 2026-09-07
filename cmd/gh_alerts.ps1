# Mirror of bash 'ghalerts' (see ~/.bash_aliases). Windows/clink only.
# Lists admin repos with their open PR count and open Dependabot alert stats:
#   REPO, URL, PRS, ALERTS, HIGHEST (severity color-coded).
# Repos without Dependabot enabled (403/404) report 0 alerts and "-" severity.
# By default only repos with open PRs and/or alerts are shown; pass -a/--all to
# list every admin repo.

# Manual parsing so both -a and --all are accepted (PowerShell's param binding
# would not recognize the double-dash form).
$All = $false
foreach ($arg in $args) {
    if ($arg -eq '-a' -or $arg -eq '--all') {
        $All = $true
    }
    else {
        [Console]::Error.WriteLine("error: unknown argument '$arg' (usage: ghalerts [-a|--all])")
        exit 2
    }
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    [Console]::Error.WriteLine("warning: 'gh' not found - can't list GitHub alerts.")
    exit 1
}

# Admin repos (full names), sorted & deduplicated. Only `.full_name` is requested
# because PowerShell 5.1 mangles embedded double-quotes in a jq string; the URL is
# derived below (identical to the API's html_url for normal repos).
$repos = @(
    & gh api --method GET --paginate user/repos `
        -f affiliation=owner,collaborator,organization_member -f per_page=100 `
        --jq '.[] | select(.permissions.admin == true) | .full_name' 2>$null |
        Sort-Object -Unique
)

if ($repos.Count -eq 0) {
    [Console]::Error.WriteLine("warning: No admin repos found (is 'gh' authenticated? Try 'gh auth status').")
    exit 1
}

$total = $repos.Count
$rows = [System.Collections.Generic.List[object]]::new()
$severityRank = 'critical', 'high', 'medium', 'low'
$i = 0
foreach ($name in $repos) {
    $i++
    $url = "https://github.com/$name"
    [Console]::Error.Write(("`rScanning {0}/{1}: {2,-50}" -f $i, $total, $name))

    # Open PRs: the Search API returns the total directly (one cheap call).
    $prs = 0
    $prsRaw = & gh api --method GET search/issues -f "q=repo:$name is:pr is:open" --jq '.total_count' 2>$null
    if ($LASTEXITCODE -eq 0 -and $prsRaw) { $prs = [int]$prsRaw }

    # Open Dependabot alerts. Repos without Dependabot return a non-2xx status
    # (e.g. 403/404), so treat a non-zero exit as "no alerts".
    $count = 0
    $highest = '-'
    $severities = @(& gh api --paginate "/repos/$name/dependabot/alerts?state=open&per_page=100" `
            --jq '.[].security_advisory.severity' 2>$null)
    if ($LASTEXITCODE -eq 0 -and $severities.Count -gt 0) {
        $count = $severities.Count
        foreach ($rank in $severityRank) {
            if ($severities -contains $rank) { $highest = $rank; break }
        }
    }

    # Only emit repos with open PRs and/or open Dependabot alerts, unless -a/--all.
    if (-not $All -and $prs -eq 0 -and $count -eq 0) { continue }

    $rows.Add([pscustomobject]@{ REPO = $name; URL = $url; PRS = $prs; ALERTS = $count; HIGHEST = $highest })
}
[Console]::Error.Write(("`r{0,-70}`r" -f '')) # Clear the progress line.

if ($rows.Count -eq 0) {
    'No admin repos with open PRs or Dependabot alerts found.'
    exit 0
}

# Aligned, color-coded table. ANSI escapes are zero-width, so coloring the last
# (HIGHEST) column does not disturb the alignment.
$columns = 'REPO', 'URL', 'PRS', 'ALERTS', 'HIGHEST'
$width = @{}
foreach ($column in $columns) {
    $width[$column] = (@($column) + @($rows | ForEach-Object { "$($_.$column)" }) |
        Measure-Object -Property Length -Maximum).Maximum
}

$esc = [char]27
$reset = "$esc[0m"
$colorFor = @{ critical = "$esc[31m"; high = "$esc[31m"; medium = "$esc[38;5;208m"; low = "$esc[33m" }
$separator = '  '

($columns | ForEach-Object { $_.PadRight($width[$_]) }) -join $separator
foreach ($row in $rows) {
    $cells = foreach ($column in $columns) {
        $value = "$($row.$column)".PadRight($width[$column])
        if ($column -eq 'HIGHEST' -and $colorFor.ContainsKey([string]$row.HIGHEST)) {
            $value = $colorFor[[string]$row.HIGHEST] + $value + $reset
        }
        $value
    }
    $cells -join $separator
}
