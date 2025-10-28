# cvclipboard
Practical way to share the cv's using automation programs

## AutoHotkey text-expansion for `/aiengineer`

This workspace adds a small AutoHotkey script that expands the typed trigger `/aiengineer` into a short greeting message.

Files included

- `aiengineer.ahk` — AutoHotkey v1 script. Type `/aiengineer` (then Space or Enter) to insert the greeting.

How it works (contract)

- Input: typing the characters `/aiengineer` in any editable text field.
- Output: replaced text `hello this is rifat erdem sahin. I am an ai engineer.`
- Error modes: If AutoHotkey is not running, nothing will happen. If the script is not saved or is blocked by antivirus, it must be allowed.
- Success criteria: typing `/aiengineer` followed by a space (or Enter) inserts the greeting.

Quick setup (Windows)

1. Install AutoHotkey (v1.x)
	- Download and install from the official site: https://www.autohotkey.com/

2. Place the script
	- Save `aiengineer.ahk` somewhere convenient (for example, your Documents folder or `C:\Users\<you>\Documents\AutoHotkey\`).

3. Run the script
	- Double-click `aiengineer.ahk` to run it. A green AutoHotkey icon should appear in the system tray.

4. Test
	- Open Notepad, Word, or a browser text field. Type `/aiengineer` then press Space (or Enter). It should expand to:

	 hello this is rifat erdem sahin. I am an ai engineer.

Run at startup (optional)

To have the script start when you sign in:

1. Press Win+R and paste `shell:startup` then press Enter.
2. Create a shortcut to `aiengineer.ahk` inside the opened Startup folder.
	- Right-click the script -> Create shortcut -> Move the shortcut to the Startup folder.

Advanced notes and customization

- Case-insensitive trigger: if you'd like `/AIEngineer` or variants to work, open `aiengineer.ahk` and change the hotstring line to:

  :i:/aiengineer::

- Add an automatic trailing space or punctuation by changing the SendRaw line. Example (adds a trailing space):

  SendRaw, hello this is rifat erdem sahin. I am an ai engineer. 

- If you want a trigger that expands immediately without requiring a terminating character, AutoHotkey can do that with more advanced Input handling. This simple hotstring uses the default behavior (works after a terminator).

Cross-platform alternatives

- Linux: espanso (https://espanso.org/) provides similar text expansion capabilities.
- macOS: use native text replacements in System Preferences or tools like TextExpander.

Security and antivirus

Some antivirus products may flag AutoHotkey scripts or compiled executables. If you compile the script to an EXE, you may need to whitelist it.

Next steps (suggested)

- If you want immediate expansion without requiring a space, I can add an advanced AHK version that uses the Input command.
- If you'd like the script compiled to an EXE for distribution, I can add instructions for compiling with the AutoHotkey compiler.

---
Generated: October 27, 2025

📂 Project Structure Explained
This project uses a unique seven-folder structure that represents a holistic development journey. Each folder has a specific purpose, guiding you through a structured and philosophical workflow.

🎯 1_Real: Objectives & Key Results
Premise: Every project must begin with a clear and measurable goal. This folder establishes the "why" behind the work.
Content: High-level objectives and key results (OKRs).
Conclusion: Aligns all work with a tangible purpose.
🗺️ 2_Environment: Roadmap & Use Cases
Premise: A goal needs a path. This folder lays out the strategic plan.
Content: Project roadmap, learning modules, and use cases.
Conclusion: Ensures a clear direction grounded in user needs.
🧠 3_UI: Knowledge & Skill Acquisition
Premise: Development is a journey of learning.
Content: A personal knowledge base for concepts, theories, and skills.
Conclusion: Fosters continuous improvement.
📚 4_Formula: Guides & Best Practices
Premise: Don't reinvent the wheel.
Content: Essential guides, formulas, and code snippets.
Conclusion: Solves challenges efficiently and ensures high quality.
💻 5_Symbols: Implementation & Code
Premise: Where theory becomes reality.
Content: The core application source code (Vite + React).
Conclusion: The heart of the project.
🐞 6_Semblance: Error Logging & Solutions
Premise: Mistakes are valuable learning opportunities.
Content: A log of bugs, errors, and their solutions.
Conclusion: Prevents repeated mistakes and accelerates development.
✅ 7_Testing: Validation & Quality Assurance
Premise: A project is only complete when proven to work.
Content: Testing scripts and documentation.
Conclusion: Guarantees quality and confirms objectives are met.