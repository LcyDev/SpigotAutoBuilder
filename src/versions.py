"""
A Python module that decodes string versions and processes them.
"""
import re

# https://hub.spigotmc.org/versions/
spigot_ref: dict[str, list[str]] = {
    '1.8' : ['1.8', '1.8.3', '1.8.4', '1.8.5', '1.8.6', '1.8.7', '1.8.8'],
    '1.9' : ['1.9', '1.9.2', '1.9.4'],
    '1.10': ['1.10', '1.10.2'],
    '1.11': ['1.11', '1.11.1', '1.11.2'],
    '1.12': ['1.12', '1.12.1', '1.12.2'],
    '1.13': ['1.13', '1.13.1', '1.13.2'],
    '1.14': ['1.14', '1.14.1', '1.14.2', '1.14.3', '1.14.4'],
    '1.15': ['1.15', '1.15.1', '1.15.2'],
    '1.16': ['1.16', '1.16.1', '1.16.2', '1.16.3', '1.16.4', '1.16.5'],
    '1.17': ['1.17', '1.17.1'],
    '1.18': ['1.18', '1.18.1', '1.18.2'],
    '1.19': ['1.19', '1.19.1', '1.19.2', '1.19.3', '1.19.4'],
    '1.20': ['1.20', '1.20.1', '1.20.2', '1.20.3', '1.20.4', '1.20.5', '1.20.6'],
    '1.21': ['1.21'],
}

def to_int_protocol(version: str) -> int:
    return int(re.sub(r'\.x$', '', version).replace('.', ''))

def to_tuple_protocol(version: str) -> tuple[int]:
    return tuple(map(int, version.strip('.x').split('.')))

class MCVersion:
    def __init__(self, value: str) -> None:
        self.value = value.lower()
        self.major = '.'.join(self.value.split('.')[:2])
        self.is_wildcard = self.value.endswith('.x')

    @property
    def protocol(self) -> tuple[int]:
        return to_tuple_protocol(self.value)

    @property
    def base_protocol(self) -> tuple[int]:
        return to_tuple_protocol(self.major)

    @property
    def has_subversion(self) -> bool:
        return len(self.protocol) > 2

    def get_values(self) -> list[str]:
        if self.is_wildcard:
            return spigot_ref.get(self.major, self.value)
        else:
            return [self.value]

    def __str__(self) -> str:
        return self.value

class RangedVersion:
    """Represents a range of Minecraft versions."""
    def __init__(self, start: MCVersion, end: MCVersion) -> None:
        self.start = start
        self.end = end

    def any_wildcards(self) -> bool:
        """Checks if either start or end version is a wildcard."""
        return self.start.is_wildcard or self.end.is_wildcard

    def both_wildcarded(self) -> bool:
        """Checks if both start and end version is a wildcard."""
        return self.start.is_wildcard and self.end.is_wildcard

    def is_major_wildcarded(self, m_protocol: tuple[int]) -> bool:
        """Checks if the major protocol matches a wildcarded version."""
        return (self.start.is_wildcard and m_protocol == self.start.base_protocol) \
            or (self.end.is_wildcard and m_protocol == self.end.base_protocol)

    def should_iterate(self, m_protocol: tuple[int]) -> bool:
        return (self.start.has_subversion and m_protocol == self.start.base_protocol) \
            or (self.end.has_subversion and m_protocol == self.end.base_protocol) \

    def get_values(self) -> list[str]:
        """Returns a list of version strings within the range."""
        result = []
        if self.start.protocol == self.end.protocol:
            if self.any_wildcards():
                result.extend(spigot_ref.get(self.start.major, self.start.value))
            else:
                result.append(self.start.value)
            return result

        for major, subversions in spigot_ref.items():
            major_protocol = tuple(map(int, major.split('.')))
            # Skip major versions that are not in the range.
            if not self.start.base_protocol <= major_protocol <= self.end.base_protocol:
                continue

            if self.both_wildcarded() or self.is_major_wildcarded(major_protocol):
                result.extend(subversions)

            elif self.should_iterate(major_protocol):
                result.extend(ver for ver in subversions
                    if self.start.protocol <= tuple(map(int, ver.split('.'))) <= self.end.protocol)
            else:
                result.append(major)
        return result

    def __str__(self):
        return f"{self.start}-{self.end}"

def decodeStringVersion(encoded: str) -> list[str]:
    """Decodes a string version and returns a set of version strings."""
    encoded = encoded.strip().replace(' ', '').lower()
    result = []
    for raw in encoded.split(','):
        if '-' in raw:
            start, end = raw.split('-')
            result.extend(RangedVersion(MCVersion(start), MCVersion(end)).get_values())
        else:
            result.extend(MCVersion(raw).get_values())
    return result

if __name__ == '__main__':
    tests = {
        "1.8.x-1.9.x": ['1.8', '1.8.3', '1.8.4', '1.8.5', '1.8.6', '1.8.7', '1.8.8', '1.9', '1.9.2', '1.9.4'],
        "1.10-1.12": ['1.10', '1.11', '1.12'],
        "1.13-1.15.x": ['1.13', '1.14', '1.15', '1.15.1', '1.15.2'],
        "1.14.x-1.15": ['1.14', '1.14.1', '1.14.2', '1.14.3', '1.14.4', '1.15'],
        "1.19.x-1.21": ['1.19', '1.19.1', '1.19.2', '1.19.3', '1.19.4', '1.20', '1.21'],
        "1.20-1.20.6": ['1.20', '1.20.1', '1.20.2', '1.20.3', '1.20.4', '1.20.5', '1.20.6'],
    }
    for k, v in tests.items():
        print(f"Decoding: {k}")
        result = decodeStringVersion(k)
        print(f"Result: {result}")
        if result == v:
            print("TEST PASSED")
        else:
            print("TEST FAILED")
        print()