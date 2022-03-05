# Polylith

## Workspaces

Workspaces are the top-level entity. You'll only need one for a long time.

Get started by creating a workspace with `poly create workspace name:<workspace_name> top-ns:<domain_tld>.<domain_name>`

Then cd into that dir and start a poly shell with `poly`.

Setup nrepl by adding alias to top deps.edn:
```
:nrepl {:extra-deps
        {nrepl/nrepl {:mvn/version "0.9.0"}
         cider/cider-nrepl {:mvn/version "0.25.2"}}
        :main-args ["-m" "nrepl.cmdline" "--middleware" "[cider.nrepl/cider-middleware]" "--interactive"]}
```
This particular setup uses a port. With Conjure just `:ConjureConnect` and it'll get the port from the `.nrepl-port` file.

## Bricks

There are two types of polylith "bricks": components and bases.

## Components

In the poly shell create a component with `poly create component name:<component_name>`

We need to add this component to the deps.edn file manually. Poly does not edit files at all.

Add these entries to the main deps.edn aliases:
```
:dev {:extra-paths ["components/<component_name>/src"
                    "components/<component_name>/resources"]}
:test {:extra-paths ["components/<component_name>/test"]}
```

Alternatively you could add the new component as extra dependency to the `:dev` alias:
```
:dev {:extra-deps {poly/<component_name> {:local/root "components/<component_name>"}}}
:test {:extra-paths ["components/<component_name>/test"]}
```
This is actually preferred because then you can control the resource paths from within the component's `deps.edn`.

> **NOTE:** `poly` is used just because it's unique. It's just a polylith best practive. All deps identifiers need to be unique.

Now add a `core` namespace to the new component:
```
echo '(ns <domain_tld>.<domain_name>.<component_name>.core)' > components/<component_name>/src/<domain_tld>/<domain_name>/<component_name>core.clj
```
Then connect the `interface` and `core` namespaces by creating a function with the same name in both and delegating to the `core` function from the `interface` function.

## Bases

Next we can create a base with `poly create base name:<base_name>` and it to the main `deps.edn`:
```
:dev {:extra-deps {poly/<base_name> {:local/root "bases/<base_name>"}}}
:test {:extra-paths ["bases/<base_name>/test"]}
```

Bases are like components except for two things:
1. They don't have an interface
2. They expose an API to the outside world

## Projects

There are two types of projects:
1. The singular development project
- This is where we work with code, often from a REPL
- It contains all libraries, components, and bases
- Uses top-level `deps.edn`
2. Deployable projects (aka every other project besides the development one)
- Used to build deployable artifacts
- Lives under the `projects` directory
- Each has its own `deps.edn`
- Normally only has one base
- Can have tests, but no source code

The aliases for each project are stored in `workspace.edn`

### Development Project

Add a personal namespace called `dev.<your_first_name>` to the development project:
```
mkdir development/dev
echo '(ns dev.stel)\n(println "hello world")' > development/dev/stel.clj
```

### Deployable Projects

Make a new project with `create project name:<project_name>` and add an alias to `workspace.edn`:
```
:projects {"<project_name>" {:alias "<project_alias>"}}
```

Now add components and bases to the project's `deps.edn`:
```
{:deps {poly/<component_name> {:local/root "../../components/<component_name>"}
        poly/<base_name>  {:local/root "../../bases/<base_name>"}
```

The poly test command will use these local repos under `:deps` to figure out what tests need to run.

### Building Projects

Add the example `build.clj` file from https://github.com/polyfy/polylith/blob/master/examples/doc-example/build.clj to the workspace root dir

Add `:uberjar` aliases to the deployable projects' `deps.edn` with just the main namespace of the uberjar:
```
:uberjar {:main <domain_tld>.<domain_name>.<base_name>.core}
```

Add a `:build` alias to the root `deps.edn`:
```
:build {:deps {io.github.seancorfield/build-clj {:git/tag "v0.5.2" :git/sha "8f75b81088b9809ec3cfc34e951036b3975007fd"}}
        :paths ["build/resources"]        
        :ns-default build}
```

Now you can run this to build uberjar:
```
clojure -T:build uberjar :project <project_name>
```

And run the uberjar:
```
java -jar projects/<project_name>/target/<project_name>.jar <args>
```

## Polylith Shell

You can get brick information by running `ws get:component:<component_name>`

> I feel like a tool that made interfaces into PDFs would be really cool

## Tags

`poly info` puts a "\*" by the bricks that have changed since the last stable commit. Stable commits are marked by git tags with start with `stable`. Stable tags should only be created if all tests are passing. Every developer can have their own stable tag called `stable-<developer_name>` and reuse it. You can reuse tags with `git tag -f`.

`poly info` also puts a "+" by the projects with at least one brick that has changed.

It's best practive to set up a CI server to tag releases for you but manually we can just tag like `git tag v0.1.0`.

Now we can get info about these tags with commands like `poly info since:release` or `poly info since:last-release`.

## Flags

s-- : project has source
-t- : project has tests
--x : project has tests that need to run
