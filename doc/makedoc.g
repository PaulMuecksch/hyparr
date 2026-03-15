LoadPackage("gapdoc");

MakeGAPDocDoc(
    "~/paul/gap-4.11.1/pkg/hyparr/doc",
    "manual",        # main XML file without extension
    [ "intro.xml",
      "constructors.xml",
      "attributes.xml",
      "operations.xml"],
    "HypArr"
);