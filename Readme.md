This is no longer maintained, because heavy logger appears unmaintained and I switched to template haskell based alternatives.

# Heavy log shortcuts

An alternative shortcut api for heavy-logger.
This has infected several of my projects already so I'm
putting it online.
Although, it maybe better to use someting like [katip](http://hackage.haskell.org/package/katip)
I just don't want to invest the time into learning another logging framework.

Removes the vars functionality, fixes not being able to use '{}'.
Puts in place some sane default shortcuts.

If we don't want data use:

```haskell
debug0 "msg"
```

if we do want data (which is almost always the case):

```haskell
debug "msg" somedata
```

If we want multiple datas:

```haskell
debug "msg" (onedata, twodata)
```

I usually import this module qualified as Log,
then you can do:

```haskell
Log.debug "oh no my house is on fire" house
```

Now it reads almost like a sentence.
