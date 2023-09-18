versions = {
    '1.8': ['1.8', '1.8.3', '1.8.8'],
    '1.9': ['1.9', '1.9.2', '1.9.4'],
    '1.10': ['1.10.2'],
    '1.11': ['1.11', '1.11.1', '1.11.2'],
    '1.12': ['1.12', '1.12.1', '1.12.2'],
    '1.13': ['1.13', '1.13.1', '1.13.2'],
    '1.14': ['1.14', '1.14.1', '1.14.2', '1.14.3', '1.14.4'],
    '1.15': ['1.15', '1.15.1', '1.15.2'],
    '1.16': ['1.16', '1.16.1', '1.16.2', '1.16.3', '1.16.4', '1.16.5'],
    '1.17': ['1.17', '1.17.1'],
    '1.18': ['1.18', '1.18.1', '1.18.2'],
    '1.19': ['1.19', '1.19.1', '1.19.2', '1.19.3', '1.19.4'],
    '1.20': ['1.20.1'],
}

class Version:
    def __init__(self, value: str):
        self.value = value
        self.isWildcard = value.lower().endswith('.x')

    def protocol(self) -> int:
        return int(self.value.strip('.x').replace('.', ''))

    def get_values(self, forceAll=False) -> list[str]:
        if self.isWildcard or forceAll:
            return versions.get(self.value.strip('.x'), [self.value])
        else:
            return [self.value]

    def __str__(self):
        return self.value

def calculate_wildcarded(first, last, version):
    return first.isWildcard and last.isWildcard or \
            first.protocol() == version.protocol() and first.isWildcard or \
            last.protocol() == version.protocol() and last.isWildcard

def decodeStringVersion(encoded: str) -> set[str]:
    encoded = encoded.strip().replace(' ', '').lower()
    result = []
    for raw in encoded.split(','):
        if '-' in raw:
            first, last = (Version(v) for v in raw.split('-'))
            for version in [Version(v) for v in versions]:
                if first.protocol() <= version.protocol() <= last.protocol():
                    wildCarded = calculate_wildcarded(first, last, version)
                    result.extend(version.get_values(forceAll=wildCarded))
        else:
            result.extend(Version(raw).get_values())
    return result

def processVersions(versions: list[str]):
    for version in versions:
        print(decodeStringVersion(version))
        print()

if __name__ == "__main__":
    tests = ["1.8.x-1.9.x", "1.10-1.12", "1.14-1.15, 1.16.x"]
    processVersions(tests)