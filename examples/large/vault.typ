#import "@local/slate:0.1.0": *


#import "@preview/fletcher:0.5.8"
#import "@preview/zap:0.5.0"
#import "@preview/cetz:0.5.2"

#let setup(body) = {
  vault(body, "JetBrainsMono NF", "catppuccin-latte")
  
}

#let diagram(..args) = {
  html.frame(fletcher.diagram(..args))
}

#let circuit(..args) = {
  html.frame(zap.circuit(..args))
}

#let canvas(..args) = {
  html.frame(cetz.canvas(..args))
}

#show: setup

#include "@local/slate:0.1.0"
