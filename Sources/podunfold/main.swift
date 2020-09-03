import PodUnfoldLib

do {
  try PodUnfold().run(args: Array(CommandLine.arguments.dropFirst()))
} catch {
  print(error.localizedDescription)
}
