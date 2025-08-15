# freecellada
Freecell card game implemented in Ada using Raylib.

# Controls

Mouse to pick and drop cards

Z to undo last move

# Building

This project uses Alire and depends on the Raylib Ada bindings. You need to install Alire (https://alire.ada.dev) before building.

Use the ```alr run``` command to build and run.

I have abstracted usage of Raylib into engine.adb, so if you can't use Alire, you can add your own imports in engine.adb and modify the linker command in freecellada.gpr to point to a prebuilt Raylib library.

# Screenshot

<img width="1386" height="934" alt="freecellada" src="https://github.com/user-attachments/assets/a7d09a94-9260-4520-960b-b2e8bc9221ea" />
