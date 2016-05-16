'use strict';


function popoutContent(){

	var header_height = removeHeader();
	fixHeight(header_height);
}

function removeHeader(){
	var header = document.getElementsByClassName("d2l-popup-title")[0];
	var header_height = header.offsetHeight;
	header.parentNode.removeChild(header);
	return header_height;
}

function fixHeight(header_height = 0) {
	//Readjust height of view
	var popup_body = document.getElementsByClassName('d2l-popup-body')[0];
	var popup_body_height = popup_body.offsetHeight;
	var view_height = popup_body_height + header_height; //header_height is for the first time only
	popup_body.style.height = view_height + "px";


	//Readjust height of fileviewer
	var content_body = document.getElementsByClassName('d2l-fileviewer-rendered-pdf')[0];
	if (content_body != null) {
		content_body.style.height = (view_height - 6) + "px";
	}
}

var timeoutId = 0;
window.addEventListener('resize', function(){
	
	if (timeoutId){
	    clearTimeout(timeoutId);
	}
	timeoutId = setTimeout(function() {
	    console.log('resize');
	    fixHeight();
	    timeoutId = 0;
	}, 200);
}, false);

popoutContent();
