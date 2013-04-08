" Vim compiler hile
" Compiler: Unit testing for Python using nose
" Maintainer: Olivier Le Thanh Duong <olivier@lethanh.be>
" Last Change: 2010 Sep 1

" Based on pyunit.vim distributed with vim
" Compiler: Unit testing tool for Python
" Maintainer: Max Ischenko <mfi@ukr.net>
" Last Change: 2004 Mar 27
"
" Modified by lambdalisue
" Last Change: 2011 Dec 12

if exists("current_compiler")
  finish
endif
let current_compiler = "nose"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet efm=%f:%l:\ fail:\ %m,%f:%l:\ error:\ %m
CompilerSet makeprg=nosetests\ $*\ -q\ --with-doctest\ --with-machineout
