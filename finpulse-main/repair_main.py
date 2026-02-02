import os

file_path = r"C:\Users\ASUS\Downloads\FinPulse365\finpulse-main\finpulse-main\lib\main.dart"

with open(file_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

# 1-based to 0-based conversion
# Line 2594 is '}' (closing _SelectAccountScreenState)
# We want to insert the method BEFORE this }
# lines[2593] is '}\n'

method_code = [
    "\n",
    "  Future<void> _showAddAccountSheet(BuildContext context, {BankAccount? account}) async {\n",
    "    await showModalBottomSheet(\n",
    "      context: context,\n",
    "      isScrollControlled: true,\n",
    "      showDragHandle: true,\n",
    "      backgroundColor: Colors.white,\n",
    "      builder: (_) => _BankFormSheet(account: account),\n",
    "    );\n",
    "  }\n"
]

# Insert method before the closing brace at 2594
# But wait, 2594 might not be EXACTLY at index 2593 if I miscounted, but context at 2098 confirms it.
# Line 2594: }
# Let's verify content at 2593
if lines[2593].strip() != "}":
    print(f"Error: Line 2594 is '{lines[2593]}', expected '}}'")
    exit(1)

# Modify the closing brace line to include the method before it?
# Or insert into list.
lines.insert(2593, "".join(method_code))

# Now handling deletion.
# Original Garbage Start: 2596 (index 2595)
# Original Garbage End: 2713 (index 2712)
# Since we inserted 1 element (which is a string, wait, insert inserts a single item, but method_code is a list)
# I should join method_code or insert multiple.
# Let's flatten lines first.
# remove the inserted item logic for a moment.

# Let's restructure:
# Keep lines 0 to 2593 (indices 0..2592) -> These are lines 1..2593.
# Line 2593 ('}') is the closing brace.
# We want to inject code before 2593?
# We want: 0..2592 + method + 2593 + ...
#
# But we also want to DELETE 2596..2713.
# Indices: 2595 to 2712.
#
# New structure:
# lines[0 : 2593]  (Lines 1 to 2593)
# method_code
# lines[2593]      (Line 2594, the '}')
# lines[2594]      (Line 2595, usually empty or newline)
# SKIP lines[2595 : 2713] (The garbage)
# lines[2713 :]    (Line 2714 onwards)

new_lines = lines[0:2593] + method_code + [lines[2593]] + [lines[2594]] + lines[2713:]

with open(file_path, "w", encoding="utf-8") as f:
    f.writelines(new_lines)

print("Successfully repaired main.dart")
