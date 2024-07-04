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
- decryption batch for folder to send to shortcuts
- if conflicts, allow for export of current local and replace with new
- have global versioning so that client knows which branches to pull from server

- allow unsafe note taking mode for user convenience (encrypted notes can't be read within the app)
- add core data client changelog + field for each log that tells if it was uploaded or not

GRAVE:
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
