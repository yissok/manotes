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
- all add tags/notes that existed before should use new `insertTree` function, this will make things easier because all changes can be applied like an onion
- fix test
- input field in main view where you can paste serialised tree and updates existing tree with new one
    - if conflicts, allow for export of current local and replace with new
- have global versioning so that client knows which branches to pull from server
- sort in backend too

- allow unsafe note taking mode for user convenience (encrypted notes can't be read within the app)
- add core data client changelog + field for each log that tells if it was uploaded or not

GRAVE:
- serialise into tree string
- go through children in alphabetical order for serialisation (both here and backend)
- deserialise
