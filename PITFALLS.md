# Common pitfalls

## How to run it

Install the recommended Vs Code extension, open the script then run by 
clicking in the button right on the top.

The default settings is at `.vscode/settings.json`, where I set up the
default GNU Octave's path for Windows OS.


## Can't save the plot

If you're on Windows and can't save the plot,
then:

Set the toolkit to GNU Plot right on the begining of the code:

```m
graphics_toolkit("gnuplot");
```

Then redirect the output on the end of the source code:

```m
print('-dpng', './question1.png');
```
