var editor = document.getElementById("editor");
editor.addEventListener("input", function(){
    try{
        // This creates a message with name : "textDidChange" and body: editor.innerHTML
        webkit.messageHandlers.textDidChange.postMessage(editor.innerHTML);
    }
    catch(err){
        editor.style.backgroundColor = "red"
    }
}, false)

editor.addEventListener("selectionhange", function(){
    try{
        webkit.messageHandlers.heightDidChange.postMessage(document.body.offsetHeight);
    }
    catch(err){
        editor.style.backgroundColor = "orange"
    }
}, false)

