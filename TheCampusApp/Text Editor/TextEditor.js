var editor = document.getElementById("editor");
var oldHeight = 60

editor.addEventListener("input", function(){
    try{
        // This creates a message with name : "textDidChange" and body: editor.innerHTML
        webkit.messageHandlers.textDidChange.postMessage(editor.innerHTML);
        let height = editor.clientHeight
        if(height != oldHeight){
            webkit.messageHandlers.heightDidChange.postMessage(height);
            oldHeight = height
        }
        
    }
    catch(err){
        editor.style.backgroundColor = "red"
    }
}, false)

editor.addEventListener("selectionchange", function(){
    try{
      webkit.messageHandlers.heightDidChange.postMessage(editor.innerHTML);
    }
    catch(err){
        editor.style.backgroundColor = "red"
    }
}, false)


