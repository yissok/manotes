# RULES
- any note has only one tag
- the name of a note is its tag
- the parent of a note is its tag
- any tag is unique 
- folders have child folders and notes
- folders have one parent
- tag and folders are the same thing

# TODO

NEXT EPISODE:
- simplify insert tree logic
- abstract shortcut 1 level for creating notes for a specific tagfolder e.g. thoughts
- version stuff
    - pull from icloud repo             ------at every startup and before each write action, do a pull on the version file and update if increased in the meantime         ------when pulling, you will know exactly the paths of the files you are missing because you can retrieve last version in o1 and you already have the old version in userdefaults, so loop through paths old version -> file last version
    - allow to navigate to whatever version
    - allow to keep current state of tree and forget all history
- ui options
    - change top 3 dots select
        - will allow to bulk move or bulk delete
    - have eye button next to top folder name to view all notes in this folder
    - keep pressed item for actions
        - NOTESONLY: note edit
        - NOTESONLY: single note view
        - delete
        - move
        - TAGSONLY: view all notes in this folder
- not enc work
    - differentiate enc/non enc notes
    - allow new note not enc input
    - allow to tap view note
    - allow user to edit note (disallow enc edit)
- restrict folder input chars and length and copypaste

GRAVE:
- reset version btn + version label
- improve modularity of overlay
- fix overlay touch over navigation stack
- move protocol
- allow all notes in current folder view
    - ~~will require new protocol accepting multiple enc strings and editing shortcut's js to list out contents~~
- history folder in files
    - txt files
    - version number file name
    - swift data last version
        - use userdefaults
- get all files under Shortcuts/manotes/ files app folder
- proper folder input
- fix test
- sort in backend too
- input field in main view where you can paste serialised tree and updates existing tree with new one
- implement deletion !
- for note name convert to date
- re introduce note from shtct
- all add tags/notes that existed before should use new `insertTree` function, this will make things easier because all changes can be applied like an onion
- create root node if no exist
- serialise into tree string
- go through children in alphabetical order for serialisation (both here and backend)
- deserialise

WON'T DO:
- server side work (if this is going to only be an ios app, let users manage their db thus allowing app to be free)
    - if conflicts, allow for export of current local and replace with new
    - have global versioning so that client knows which branches to pull from server
    - add core data client changelog + field for each log that tells if it was uploaded or not
- allow unsafe note taking mode for user convenience (encrypted notes can't be read within the app)
