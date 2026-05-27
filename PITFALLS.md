# Common pitfalls

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
