# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

# foldCode = (editor) ->
    # editor.foldAllAtIndentLevel(0)

# Add callback for when a text editor is added
# atom.workspace.observeTextEditors(foldCode)

atom.workspace.onDidAddTextEditor (event) ->
  atom.commands.dispatch(atom.views.getView(event.textEditor), 'editor:fold-at-indent-level-1')
