# roblezno-nvim
*Work in progress*

My personal config of nvim.

### A bit of background
I started this project with the idea of learning how an IDE really works. I used to use VSCode all the time and,
while I still like it, it got me furious some times. I didn't know how programming languages really interact with the IDE,
meaning treesitter, lsp and all those features. Fully fledged IDEs like VSCode have way to much configuration options and prebuilt
stuff, I wanted something more minimal, more raw, that I could personalize and deeply understand. I need to know if something fails
why is it failing, where the error comes from and how to handle it.

### My experience in Neovim
So I decided to start configuring my own neovim setup. I tried kickstar and LazyVim for a while and I liked them, but I still wanted more.
I got hooked by the nvim experience. Then i created my own config, the one I still use, but its just a mess.
I used a mix of IA, tutorials and docs to build it and it got out of controll really quick. Its great, but not optimal as I would like.

### The idea of this config
With all the knowledge I adquired in my previous setups, here I come again trying to get my definitive nvim config. The idea of this project
is to have a fully working IDE for bioinformatics, minimal but not to an extreme. I want it to be quick and responsive but still have everything I need.
It is also serving as a testing field for learning to properly use git in a decently sized project.

Features:
* Ready to manage lsp inside envs like conda and with docker for python and R.
* Ready to work with terminal multiplexers like tmux (or internal nvim terminals)
* Ready to work with quarto markdown files and code chunks inside them
* Flexible and easily expandible to other languages for things like web apps development
* Easy to work with git (lazygit)
* Fuzzyfind with telescope and tree with neo tree
* Pretty interface ( I love customizing the way my IDE looks ) and easy to modify
