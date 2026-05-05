import os
import sys

# Make agents/ and tools/ importable in tests without installing the package.
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)
