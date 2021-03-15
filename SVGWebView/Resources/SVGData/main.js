const PATH_SELECTOR = "[id^=path-]"

var paths;
var canEdit = true;

window.onload = function () {}

function loadSVG(rawSVG) {
    document.getElementById("body").innerHTML = rawSVG
    setupPaths()
}

function setupPaths() {
    paths = document.querySelectorAll(PATH_SELECTOR)
    
    paths.forEach(path => {
        path.style.fill = "#FFFFFF"
        path.style.stroke = "#000000"
        path.style.strokeWidth = "0.1px"
        
        path.onclick = (event) => {
            webkit.messageHandlers.didTapPath.postMessage(event.target.id)
        }
    })
    
    let pathsInfo = []
    paths.forEach(path => {
        const rect = path.getBoundingClientRect()
        const data = { id: path.id, x: rect.x, y: rect.y, width: rect.width, height: rect.height }
        pathsInfo.push(data)
    })
    const elementsString = JSON.stringify(pathsInfo)
    webkit.messageHandlers.transferPathsInfo.postMessage(elementsString)
}

function drawColor(pathID, color) {
    let path = document.getElementById(pathID)
    if (path != null) {
        path.style.fill = color
        path.style.stroke = "transparent"
        path.style.strokeWidth = "0px"
    }
}

function clearAll() {
    paths.forEach(path => {
        path.style.fill = "#FFFFFF"
        path.style.stroke = "#000000"
        path.style.strokeWidth = "0.1px"
    })
}

/// Log
function log(object) {
    var message = JSON.stringify(object, null, " ")
    webkit.messageHandlers.log.postMessage(message)
}
