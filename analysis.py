
import csv
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Mapping, Optional, Self
from collections import defaultdict
import matplotlib.pyplot as plt


@dataclass
class DataPoint:
    date: int
    exercise: str
    reps: int
    weight: float

    @classmethod
    def create_from_list(cls, args: list) -> Optional[Self]:
        try:
            date = int(args[0])
            exercise = str(args[1])
            reps = int(args[2])
            weight = float(args[3])
        except ValueError:
            return None
        d = cls(
            date=date,
            exercise=exercise,
            reps=reps,
            weight=weight,
        )
        return d


def normalize_date(date: int) -> int:
    return int(date/(24*60*60.))

def parse_volume_data(file: Path) -> Optional[Mapping[str, Mapping]]:
    if not file.exists():
        return None

    def fact():
        return defaultdict(float)

    volume_data = defaultdict(fact)
    with file.open() as f:
        reader = csv.reader(f)
        for row in reader:
            point = DataPoint.create_from_list(row)
            if not point:
                print("WARN: invalid data point.")
                continue
            vol = point.reps*point.weight
            volume_data[point.exercise][normalize_date(point.date)] += vol
    return volume_data

def plot_volume_data(volume_data: Mapping[str, Mapping]) -> None:
    fig, ax = plt.subplots()
    for ex, data in volume_data.items():
        vol_data = list(data.values())
        if not vol_data:
            continue
        ax.plot(vol_data, label=ex)
    plt.title("title")
    plt.xlabel("Time")
    plt.ylabel("Volume (Kg)")
    plt.legend()
    plt.show()
    return


def main() -> None:
    data_path = Path(sys.argv[1])
    data = parse_volume_data(data_path)
    if not data:
        print("Data parsing error.")
        return
    plot_volume_data(data)
    return


if __name__ == "__main__":
    main()

#bomm
