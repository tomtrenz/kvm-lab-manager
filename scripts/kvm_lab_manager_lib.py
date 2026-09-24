"""Pure, side-effect-free helpers shared by the CLI and unit tests."""
import hashlib
import json
import os
import re
import tempfile
from pathlib import Path

IDENTIFIER = re.compile(r"^[A-Za-z0-9][A-Za-z0-9_.-]{0,127}$")


def validate_identifier(value, label):
    if not isinstance(value, str) or not IDENTIFIER.fullmatch(value):
        raise ValueError("%s must match %s" % (label, IDENTIFIER.pattern))
    return value


def is_within(root, candidate):
    root_real = os.path.realpath(root)
    candidate_real = os.path.realpath(candidate)
    return os.path.commonpath((root_real, candidate_real)) == root_real


def safe_child(root, *parts):
    if not parts or any(not isinstance(part, str) or not part or part in (".", "..") or "/" in part or "\\" in part or part.startswith(("~", "$")) for part in parts):
        raise ValueError("unsafe path component")
    result = os.path.join(root, *parts)
    if not is_within(root, result):
        raise ValueError("path escapes root")
    return result


def domain_name(project_id, run_id, vm_name):
    values = [validate_identifier(item, "identifier") for item in (project_id, run_id, vm_name)]
    raw = "-".join(values)
    return raw if len(raw) <= 250 else "%s-%s" % (raw[:240], hashlib.sha256(raw.encode()).hexdigest()[:9])


def canonical_json(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False)


def sha256_file(path):
    digest = hashlib.sha256()
    with open(path, "rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def atomic_json_write(path, value):
    destination = Path(path)
    destination.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(prefix=".%s." % destination.name, dir=str(destination.parent))
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as stream:
            json.dump(value, stream, sort_keys=True, indent=2, ensure_ascii=False)
            stream.write("\n")
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, destination)
    except BaseException:
        try:
            os.unlink(temporary)
        except FileNotFoundError:
            pass
        raise


def confirmation(value, expected):
    return value == expected
