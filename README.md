# heroku-buildpack-sbcl

Buildpack for SBCL on Heroku.

## Environment

### The Operating System

- [The Cedar-14 Stack](https://devcenter.heroku.com/articles/stack "Stacks")
  (Based on [Ubuntu 14.04](http://www.ubuntu.com/ "An Open Source Operating System"))
  on [Heroku](https://www.heroku.com/ "A cloud Platform-as-a-Service (PaaS)")

- [Available Operating System Packages](https://devcenter.heroku.com/articles/cedar-ubuntu-packages "Ubuntu Packages on Cedar-10 and Cedar-14")

### Requirements / Dependencies

- [Steel Bank Common Lisp (SBCL)](http://sbcl.org/ "A high performance Common Lisp compiler")

- [Quicklisp](https://www.quicklisp.org/ "A library manager for Common Lisp")

- [Another System Definition Facility (ASDF)](https://www.common-lisp.net/project/asdf/ "Another System Definition Facility")

## Usage

Write a file named _build.lisp_ in the root of your source tree to build the
system.

```lisp
(log-title "Building system ...")
(ql:quickload :any-thing-you-want)
(log-footer "")
```

(*Optional*) Write a file named _build.env_ in the root of your source tree
to define environment variables.

```bash
export SBCL_VERSION="sbcl-1.3.17-x86-64-linux"
```

Write a file named _Procfile_ in the root of your source tree to start the
server.

```
web: sbcl --script web-launcher.lisp
```

Write a file named _web-launcher.lisp_ in the root of your source tree for
_Procfile_ to execute.

```lisp
(require :asdf)
(asdf:disable-output-translations)
(defvar *port* (parse-integer (asdf::getenv "PORT")))
(load "root/quicklisp/setup.lisp")
(require :web-server)
(web-server:start :port *port*)
```

### Examples

- [Run Hunchentoot](https://github.com/yangby/heroku-example-sbcl-hunchentoot)

## References

- [Buildpack API | Heroku Dev Center](https://devcenter.heroku.com/articles/buildpack-api)

- [Buildpacks | Heroku Dev Center](https://devcenter.heroku.com/articles/buildpacks)

- [Third-Party Buildpacks | Heroku Dev Center](https://devcenter.heroku.com/articles/third-party-buildpacks)

- [Process Types and the Procfile | Heroku Dev Center](https://devcenter.heroku.com/articles/procfile)

- [mtravers/heroku-buildpack-cl](https://github.com/mtravers/heroku-buildpack-cl)

- [avodonosov/heroku-buildpack-cl2](https://github.com/avodonosov/heroku-buildpack-cl2)

- [orivej/heroku-buildpack-cl](https://github.com/orivej/heroku-buildpack-cl)

- [ddollar/heroku-buildpack-apt](https://github.com/ddollar/heroku-buildpack-apt)
