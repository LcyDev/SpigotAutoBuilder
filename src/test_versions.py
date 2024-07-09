import unittest
from versions import decodeStringVersion

class TestDecodeStringVersion(unittest.TestCase):
    def test_single_versions(self):
        tests = {
            "1.12": ['1.12'],
            "1.13.1": ['1.13.1'],
            "1.14.x": ['1.14', '1.14.1', '1.14.2', '1.14.3', '1.14.4'],
            "1.16.x": ['1.16', '1.16.1', '1.16.2', '1.16.3', '1.16.4', '1.16.5'],
        }
        for input_version, expected_output in tests.items():
            with self.subTest(input_version=input_version):
                self.assertEqual(decodeStringVersion(input_version), expected_output)

    def test_ranged_versions(self):
        tests = {
            "1.8.x-1.9.x": ['1.8', '1.8.3', '1.8.4', '1.8.5', '1.8.6', '1.8.7', '1.8.8', '1.9', '1.9.2', '1.9.4'],
            "1.10-1.12": ['1.10', '1.11', '1.12'],
            "1.13-1.15.x": ['1.13', '1.14', '1.15', '1.15.1', '1.15.2'],
            "1.14.x-1.15": ['1.14', '1.14.1', '1.14.2', '1.14.3', '1.14.4', '1.15'],
            "1.19.x-1.21": ['1.19', '1.19.1', '1.19.2', '1.19.3', '1.19.4', '1.20', '1.21'],
        }
        for input_version, expected_output in tests.items():
            with self.subTest(input_version=input_version):
                self.assertEqual(decodeStringVersion(input_version), expected_output)

    def test_edge_cases(self):
        tests = {
            "1.8-1.8": ['1.8'],
            "1.8.x-1.8.x": ['1.8', '1.8.3', '1.8.4', '1.8.5', '1.8.6', '1.8.7', '1.8.8'],
            "1.20-1.20.6": ['1.20'],
        }
        for input_version, expected_output in tests.items():
            with self.subTest(input_version=input_version):
                self.assertEqual(decodeStringVersion(input_version), expected_output)

if __name__ == "__main__":
    unittest.main()