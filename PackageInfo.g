#
# HypArr: Computations with hyperplane arrangements  
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "HypArr",
Subtitle := "Computations with hyperplane arrangements.",
Version := "0.1",
Date := "17/03/2026", # dd/mm/yyyy format
License := "GPL-3.0-or-later",

Persons := [
  rec(
    FirstNames := "Paul",
    LastName := "Mücksch",
    WWWHome := "https://paulmuecksch.github.io",
    Email := "paul.muecksch+uni@gmail.com",
    IsAuthor := true,
    IsMaintainer := true,
    PostalAddress := "Welfengarten 1, 30167 Hannover, Germany",
    Place := "Welfengarten 1, 30167 Hannover, Germany",
    Institution := "Leibniz University Hannover",
  ),
],

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/PaulMuecksch/hyparr",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := "https://github.com/PaulMuecksch/hyparr",
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL      := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "HypArr",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Computations with hyperplane arrangements ",
),

Dependencies := rec(
  GAP := ">= 4.10",
  NeededOtherPackages := [ ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

Keywords := [ "TODO" ],

));


