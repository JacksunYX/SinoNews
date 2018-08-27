varMyApp_SearchResultCount =0;

function MyApp_HighlightAllOccurencesOfStringForElement(element,keyword) {
    
    if(element) {
        
        if(element.nodeType ==3) {// Text node
            
            while(true) {
                
                varvalue = element.nodeValue;// Search for keyword in text node
                
                varidx = value.toLowerCase().indexOf(keyword);
                
                if(idx <0)break;// not found, abort
                
                varspan = document.createElement("span");
                
                vartext = document.createTextNode(value.substr(idx,keyword.length));
                
                span.appendChild(text);
                
                span.setAttribute("class","MyAppHighlight");
                
                span.style.backgroundColor="red";
                
                span.style.color="black";
                
                text = document.createTextNode(value.substr(idx+keyword.length));
                
                element.deleteData(idx, value.length - idx);
                
                varnext = element.nextSibling;
                
                element.parentNode.insertBefore(span, next);
                
                element.parentNode.insertBefore(text, next);
                
                element = text;
                
                MyApp_SearchResultCount++;// update the counter
                
            }
            
        }elseif(element.nodeType ==1) {// Element node
            
            if(element.style.display !="none"&& element.nodeName.toLowerCase() !='select') {
                
                for(vari=element.childNodes.length-1; i>=0; i--) {
                    
                    MyApp_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
                    
                }
                
            }
            
        }
        
    }
    
}

function MyApp_HighlightAllOccurencesOfString(keyword) {
    
    MyApp_RemoveAllHighlights();
    
    MyApp_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
    
}

function MyApp_RemoveAllHighlightsForElement(element) {
    
    if(element) {
        
        if(element.nodeType ==1) {
            
            if(element.getAttribute("class") =="MyAppHighlight") {
                
                vartext = element.removeChild(element.firstChild);
                
                element.parentNode.insertBefore(text,element);
                
                element.parentNode.removeChild(element);
                
                returntrue;
                
            }else{
                
                varnormalize =false;
                
                for(vari=element.childNodes.length-1; i>=0; i--) {
                    
                    if(MyApp_RemoveAllHighlightsForElement(element.childNodes[i])) {
                        
                        normalize =true;
                        
                    }
                    
                }
                
                if(normalize) {
                    
                    element.normalize();
                    
                }
                
            }
            
        }
        
    }
    
    returnfalse;
    
}

// the main entry point to remove the highlights

function MyApp_RemoveAllHighlights() {
    
    MyApp_SearchResultCount =0;
    
    MyApp_RemoveAllHighlightsForElement(document.body);
    
}


