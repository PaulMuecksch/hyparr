##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##  
##  Call this with GAP.
##  We will use PackageInfo to find hyparr's path.

# if fail = LoadPackage("AutoDoc", ">= 2022.07.10") then
#     Error("AutoDoc 2022.07.10 or newer is required");
# fi;
# AutoDoc(rec(
#     gapdoc := rec( main := "hyparr.xml" ),
# ));
# QUIT;

LoadPackage( "AutoDoc" );
AutoDoc( rec(
            scaffold := rec(
            bib := "hyparr.bib",
            ),
            autodoc := rec(
            files := ["gap/arrangements.gd", "gap/specialarrs.gd", "gap/orientedmatroid.gd", 
                "gap/freearrs.gd", "gap/morearrprops.gd", "gap/milnorfiber.gd",
                "gap/topeposet.gd","gap/drawarrs.gd","gap/realizationspace.gd"] 
                ),
            gapdoc := rec(
                LaTeXOptions := rec(
                    LateExtraPreamble := "\\usepackage{graphicx,amsfonts,amsmath, amssymb}"
                )
            ),
            extract_examples := true
            ) );
QUIT;

