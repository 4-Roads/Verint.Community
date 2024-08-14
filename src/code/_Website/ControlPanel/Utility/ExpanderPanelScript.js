function ExpanderPanel_Toggle( targetID, buttonID, trackerID, imageUrl, collapsedImageUrl ) {
	if ( document.getElementById ) {
		var target = document.getElementById( targetID );
		if ( target != null ) {
			target.style.display = ( target.style.display != "none" ) ? "none" : "";
		}
		if ( collapsedImageUrl != "" ) {
			var imageButton = document.getElementById( buttonID );
			if ( imageButton != null ) {
				imageButton.src = ( target.style.display != "none" ) ? collapsedImageUrl : imageUrl;
			}
		}
		var tracker = document.getElementById( trackerID );
		if ( tracker != null ) {
			tracker.value = ( target.style.display == "none" ) ? "True" : "False";
		}
		return false;
	}
	return true;
}
