{
  # import everything in this directory top-level
  imports =
    builtins.readDir ./.
    |> builtins.attrNames
    |> builtins.filter (name: name != "default.nix") # ignore this file
    |> map (name: ./${name});
}
