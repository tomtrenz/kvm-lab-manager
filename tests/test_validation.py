import json
import os
import tempfile
import unittest
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parents[1] / "scripts"))
import kvm_lab_manager_lib as lib


class ValidationTests(unittest.TestCase):
    def test_identifier_and_path_validation(self):
        self.assertEqual(lib.validate_identifier("project-1", "project"), "project-1")
        with self.assertRaises(ValueError):
            lib.validate_identifier("../escape", "project")
        with self.assertRaises(ValueError):
            lib.safe_child("/srv/lab", "/etc/passwd")

    def test_deterministic_domain_name(self):
        args = ("project", "run", "vm")
        self.assertEqual(lib.domain_name(*args), lib.domain_name(*args))
        self.assertNotEqual(lib.domain_name(*args), lib.domain_name("project", "other", "vm"))

    def test_atomic_json_and_registry(self):
        with tempfile.TemporaryDirectory() as root:
            target = os.path.join(root, "registry.json")
            lib.atomic_json_write(target, {"b": 2, "a": 1})
            self.assertEqual(json.loads(Path(target).read_text()), {"a": 1, "b": 2})
            self.assertTrue(lib.is_within(root, target))

    def test_confirmation(self):
        self.assertTrue(lib.confirmation("destroy", "destroy"))
        self.assertFalse(lib.confirmation("DESTROY", "destroy"))


if __name__ == "__main__":
    unittest.main()
