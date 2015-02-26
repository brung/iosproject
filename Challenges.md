# Surv

## Challenges faced while developing
   * Custom views. We had autolayout problems when programmtically inserting views into a view contained in a uitableview cell.
   * Animation - trying to figure out where things were on the screen.  Trying to limit animations to certain screens.
   * UI Changes - Started out with tab navigation, to header navigation
   * Architecting Database - Had to redo our database a few times because NoSQL is not the same as MySQL so best to keep all data for a single page in one table. But that's difficult for something like comments/answers where you have one to n mappings
