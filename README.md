# SVGWebView

## Render and Interact SVG with WKWebView

Hello everybody. We recently finished a project name Seat selection. It is a module allow use can directly select the seat in a map, it seems like choose the seat in the movie theater but bigger. We applied for one stadium with 40.000 seats. Because that is a private project so I can not show anything about that.

When starting the POC of that project, we know that iOS does not support SVG natively so we choose some library to render and interact with SVG file, one of that is Macaw. Luckily, It works perfectly at that time, smooth and nothing to complain about that library. We did POC successfully with the map include 3000 seats. And when we heard that we will apply that to the map with 40000 seats, we tried with 15000 seats. Unfortunately, the performance is really bad, slowly render and slowly respond when the user taping in. We trying to find another solution again. And we choose the way to load SVG directly into WKWebView and use Javascripts to handle the interaction of users.

Before dive into the technical, I will show the demo first.

[![Demo](https://img.youtube.com/vi/gpVif37rmrE/0.jpg)](https://www.youtube.com/watch?v=gpVif37rmrE)
