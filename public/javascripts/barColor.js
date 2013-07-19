function hexColor(color, maxNumber){
	var colorArr = new Array();
	var first = Math.round((maxNumber*color)/16) == 16 ? 15 : Math.round((maxNumber*color)/16);
	var second = (Math.round(maxNumber*color) - (first*16)) < 0 ? 0 : (Math.round(maxNumber*color) - (first*16));

	switch(first){
		case 0:
			colorArr.push("0");
			break;
		case 1:
			colorArr.push("1");
			break;
		case 2:
			colorArr.push("2");
			break;
		case 3:
			colorArr.push("3");
			break;
		case 4:
			colorArr.push("4");
			break;
		case 5:
			colorArr.push("5");
			break;
		case 6:
			colorArr.push("6");
			break;
		case 7:
			colorArr.push("7");
			break;
		case 8:
			colorArr.push("8");
			break;
		case 9:
			colorArr.push("9");
			break;
		case 10:
			colorArr.push("a");
			break;
		case 11:
			colorArr.push("b");
			break;
		case 12:
			colorArr.push("c");
			break;
		case 13:
			colorArr.push("d");
			break;
		case 14:
			colorArr.push("e");
			break;
		case 15:
			colorArr.push("f");
			break;
	}

	switch(second){
		case 0:
			colorArr.push("0");
			break;
		case 1:
			colorArr.push("1");
			break;
		case 2:
			colorArr.push("2");
			break;
		case 3:
			colorArr.push("3");
			break;
		case 4:
			colorArr.push("4");
			break;
		case 5:
			colorArr.push("5");
			break;
		case 6:
			colorArr.push("6");
			break;
		case 7:
			colorArr.push("7");
			break;
		case 8:
			colorArr.push("8");
			break;
		case 9:
			colorArr.push("9");
			break;6
		case 10:
			colorArr.push("a");
			break;
		case 11:
			colorArr.push("b");
			break;
		case 12:
			colorArr.push("c");
			break;
		case 13:
			colorArr.push("d");
			break;
		case 14:
			colorArr.push("e");
			break;
		case 15:
			colorArr.push("f");
			break;
	}

	return colorArr.join("");
}

function barColor(width){
	var red = new Array();
	var green = new Array();
	var greenRed = new Array();
	
	if(width > 50){
		green.push("ff", "a0");
		red.push(hexColor(1-((width-50)/50), 255), hexColor(1-((width-50)/50), 160));
	}
	else if(width == 50){
		red.push("ff", "a0");
		green.push("ff", "a0");
	}
	else{
		red.push("ff", "a0");
		green.push(hexColor((width/50), 255), hexColor((width/50), 160));
	}
	greenRed.push(red, green);
	
	return greenRed;
}
