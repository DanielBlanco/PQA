// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/** 
 * Bookmark site function. 
 */
function bookmarksite(title,url) {
	if (window.sidebar) {// firefox
 		window.sidebar.addPanel(title, url, "");
	} else if(window.opera && window.print) { // opera
 		var elem = document.createElement('a');
 		elem.setAttribute('href',url);
 		elem.setAttribute('title',title);
 		elem.setAttribute('rel','sidebar');
 		elem.click();
	} else {// ie
		window.external.AddFavorite(url, title);
	}
}

function show_hide_search_options(){
	var row = document.getElementById("searchRow");
	if(row.style.display == 'none'){
		row.style.display = '';			
	}else{
		row.style.display = 'none';			
	}
}
