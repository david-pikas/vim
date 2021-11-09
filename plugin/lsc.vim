" lsc config

if !has('nvim')
  
  let g:lsc_server_commands = {
   \    'haskell': {
   \        'command': 'haskell-language-server-wrapper --lsp'
   \    },
   \    'javascript': {
   \        'command': 'typescript-language-server --stdio'
   \    },
   \    'latex': {
   \        'command': 'texlab'
   \    },
   \    'python': {
   \        'command': 'pyls'
   \    },
   \    'rust': {
   \        'command': 'rls'
   \    }
   \}
  
  let g:lsc_auto_map = {
   \    'GoToDefinition': 'gd',
   \    'FindReferences': 'gr',
   \    'Rename': 'gR',
   \    'ShowHover': v:true,
   \    'FindCodeActions': 'ga',
   \    'Completion': 'omnifunc',
   \}
  " format not available but f= is currently used for that by
  " ~/.config/nvim/init.vim

endif
