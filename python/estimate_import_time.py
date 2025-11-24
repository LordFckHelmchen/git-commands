# /// script
# requires-python = ">=3.7"
# dependencies = []
# ///
# SPDX-FileCopyrightText: Copyright (c) 2025 Koninklijke Philips N.V
# SPDX-License-Identifier: LicenseRef-PhilipsProprietary


import argparse
import importlib
import statistics
import sys
import time
import timeit


class _ImportTimings:
    def __init__(
        self,
        module_name: str,
        unit_of_measure: str,
        initial: list[float],
        subsequent: list[float],
        subsequent_timeit_mean: float,
    ) -> None:
        self.module_name = module_name
        self.unit_of_measure = unit_of_measure
        self.initial = initial
        self.subsequent = subsequent
        self.subsequent_timeit_mean = subsequent_timeit_mean

    def print_stats(self) -> None:
        """Print statistics of import timings in a markdown table."""
        col_width = 11
        precision = 3
        n_cols = 8  # Type, Min, Q1, Median, Mean, Q3, Max, Std
        mean_stat_col = 4  # Excluding Type

        print(
            f"| {'Type':{col_width}} | {'Min':{col_width}} | {'Q1':{col_width}} | {'Median':{col_width}} | {'Mean':{col_width}} | {'Q3':{col_width}} | {'Max':{col_width}} | {'StdErr':{col_width}} |"  # noqa: E501
        )
        print(f"| {'-' * col_width} " * n_cols, end="|\n")
        for import_type, times in {"initial": self.initial, "subsequent": self.subsequent}.items():
            t_mean = statistics.mean(times)
            t_stderr = statistics.pstdev(times) / (len(times) ** 0.5)
            t_min = min(times)
            t_max = max(times)
            t_q1, t_median, t_q3 = statistics.quantiles(times, n=4)

            # Print all stats in milliseconds
            print(f"| {import_type:{col_width}} ", end="")
            for stat in [t_min, t_q1, t_median, t_mean, t_q3, t_max, t_stderr]:
                print(f"| {stat:{col_width}.{precision}f} ", end="")
            print("|")

        # Print timeit mean
        print(f"| {'via timeit':>{col_width}} ", end="")
        print(f"| {'--':>{col_width}} " * (mean_stat_col - 1), end="")
        print(f"| {self.subsequent_timeit_mean:{col_width}.{precision}f} ", end="")
        print(f"| {'--':>{col_width}} " * (n_cols - mean_stat_col - 1), end="|\n")
        print(f"  Unit-of-Measure: {self.unit_of_measure}")


def _assert_module_is_importable(name: str) -> None:
    try:
        importlib.import_module(name)
    except ImportError:
        print(f"ERROR: Couldn't import module '{name}'! Make sure it is installed in your active Python environment?")
        sys.exit(1)


def _remove_module_and_submodules(name: str) -> None:
    to_delete = [m for m in list(sys.modules) if m == name or m.startswith(name + ".")]
    for key in to_delete:
        del sys.modules[key]
    importlib.invalidate_caches()


def estimate_import_time_in_ms(module_name: str) -> float:
    """
    Measure timing for importing the given module using time.perf_counter.

    Returns
    -------
    time_in_ms
        Time taken to import the module in milliseconds.
    """
    t0 = time.perf_counter()
    _ = importlib.import_module(module_name)
    t1 = time.perf_counter()
    return (t1 - t0) * 1000  # Convert to milliseconds


def estimate_initial_and_subsequent_import_times(module_name: str, n_runs: int) -> _ImportTimings:
    """
    Measure timings for the initial and subsequent imports of the given module.

    Returns
    -------
    import_times_in_ms
        Dictionary with lists of timings in milliseconds for 'initial' and 'subsequent' imports
    """
    timings = _ImportTimings(
        module_name=module_name,
        unit_of_measure="ms",
        initial=[None] * n_runs,
        subsequent=[None] * n_runs,
        subsequent_timeit_mean=None,
    )

    # Repeat to reduce noise
    for i in range(n_runs):
        _remove_module_and_submodules(module_name)

        # Initial import
        timings.initial[i] = estimate_import_time_in_ms(module_name)

        # Subsequent import
        timings.subsequent[i] = estimate_import_time_in_ms(module_name)

    def import_module() -> None:
        importlib.import_module(module_name)

    # Subsequent via timeit (excludes setup costs)
    _remove_module_and_submodules(module_name)
    timings.subsequent_timeit_mean = timeit.timeit(import_module, setup=import_module, number=n_runs) * (1000 / n_runs)

    return timings


def count_imported_modules(module_name: str) -> tuple[int, int]:
    """
    Count how many modules were imported as part of importing the given module.

    Returns
    -------
    n_modules
        Number of top-level modules imported.
    n_submodules
        Number of sub-modules imported.
    """
    _remove_module_and_submodules(module_name)
    modules_before = set(sys.modules.keys())
    assert module_name not in sys.modules, f"Module {module_name} was already imported!"  # noqa: S101  Allow asserts here
    importlib.import_module(module_name)
    diff = set(sys.modules) - modules_before
    submodules = {m for m in diff if "." in m}
    modules = diff - submodules
    return len(modules), len(submodules)


def estimate_import_time(module_name: str, number_of_runs: int) -> None:
    """Estimate the time to import the given module initially & in subsequent import statements."""
    print()
    print(f"Module under test: {module_name}")
    print(f"Number of runs   : {number_of_runs}")
    print(f"Date of test     : {time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())}")
    print(f"Python version   : {sys.version}")
    print(f"Executable       : {sys.executable.replace('\\', '/')}")
    print()
    _assert_module_is_importable(module_name)

    import_times = estimate_initial_and_subsequent_import_times(module_name, n_runs=number_of_runs)
    import_times.print_stats()
    print()

    n_modules, n_submodules = count_imported_modules(module_name)
    print(f"Number of imported modules: {n_modules} module(s) & {n_submodules} submodule(s)")
    print()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description=f"{estimate_import_time.__doc__} Usage example: `path/to/executable/with/module/python estimate_import_time.py pandas -n 20`"  # noqa: E501
    )
    parser.add_argument("module", type=str, help="Module name to import (default: pandas)")
    parser.add_argument("-n", "--runs", type=int, default=100, help="Number of runs to compute over (default: 10)")
    args = parser.parse_args()
    module_name = args.module
    number_of_runs = args.runs

    estimate_import_time(module_name=module_name, number_of_runs=args.runs)
