<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE HTML>
<html>
<head>
	<title>Home</title>
	<link href="/resources/css/kotlin.css" rel="stylesheet"/> 
</head>
<body onLoad="init()">
	<a href="http://192.168.0.252/LoginForm" >로그인폼 이동</a><br />
	<P>  Now Time : ${Access} </P>
	<section id="movieZone" style="display:flex;">
		<div id="movieInfo"></div>
		<div id="selectionDate"><h2>Screening Date</h2></div>
		<div id="selectionTime"><h2>SelectionTime</h2></div>
				
	</section>
</body>
<script>
let screeningData;
function init(){
	/* Convert Date */
	let dateList = document.getElementById("selectionDate"); 
	let dayStr = "${Access}"; //2021-02-03 화요일
	let day = (dayStr.split(" "))[0].split("-"); // 2021  02  03
	let now = new Date(parseInt(day[0]), parseInt(day[1])-1, parseInt(day[2]));
	
	for(i=0; i < 7; i++){	
		now.setDate(now.getDate() + ((i==0)?0:1));
		let dateDiv = document.createElement('Div');
		let month = ((now.getMonth()+1)<10)? "0"+(now.getMonth()+1) : (now.getMonth()+1);
		let date = (now.getDate() < 10)? "0" + now.getDate() : now.getDate();
		dateDiv.textContent = now.getFullYear() + "-" + month +"-" + date;
		dateDiv.style.cursor = "pointer";
		dateDiv.addEventListener('click', function(){divClick( movie[0].mvCode, this.textContent);});
		dateList.appendChild(dateDiv);
	}
	
	let movieInfo = document.getElementById("movieInfo");
	/* Append movieInfo Div */
	let movie = JSON.parse('${movieData}');
	
	let mvImage = document.createElement('Div');
	mvImage.className = "movie";
	mvImage.style.height = "300px";
	mvImage.style.backgroundImage = "url(/resources/images/" + movie[0].mvImage + ")";
	movieInfo.appendChild(mvImage);
	
	let mvTitle = document.createElement('Div');              
	mvTitle.textContent = movie[0].mvName;
	mvTitle.className = "movie";
	movieInfo.appendChild(mvTitle);
	
	let mvGrade = document.createElement('Div');              
	mvGrade.textContent = movie[0].mvGrade;
	mvGrade.className = "movie";
	movieInfo.appendChild(mvGrade);
	
	let mvStatus = document.createElement('Div');              
	mvStatus.textContent = movie[0].mvStatus;
	mvStatus.className = "movie";
	movieInfo.appendChild(mvStatus);
	
	let mvComments = document.createElement('Div');              
	mvComments.textContent = movie[0].mvComments;
	mvComments.className = "movie";
	movieInfo.appendChild(mvComments);
}

function divClick(mvCode, mvDate){
	let request = new XMLHttpRequest();
	request.onreadystatechange = function(){
		if(this.readyState == 4 && this.status == 200){
			let jsonData = decodeURIComponent(request.response);
			screeningData = JSON.parse(jsonData);
			screening();
				//screening(jsonData);
		}
	};
	
	request.open("POST", "Step3", true);
	request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
	request.send("sCode=Step3&mvCode="+mvCode+"&mvDate="+mvDate);
}

function screening(){
	let sTime = document.getElementById("selectionTime"); 

	for(index=0; index < screeningData.length; index++){
		let i = index;
		let tDiv = document.createElement("div");
		let tImg = document.createElement("img");
		tImg.src = "/resources/images/"+ screeningData[index].mvGrade+".jpg";
		
		let tScreen = document.createElement("input");
		tScreen.type = "button";
		tScreen.value = screeningData[index].mvTime + " " + screeningData[index].mvScreen + "관";
		tScreen.style.cursor = "pointer";
		tScreen.addEventListener('click', function(){
			tScreenClick(i);
		});
		
		tDiv.appendChild(tImg);
		tDiv.appendChild(tScreen);
		
		sTime.appendChild(tDiv);
	}
}

function tScreenClick(index){
	let formData = "sCode=Step4&mvCode=" + screeningData[index].mvCode + 
	"&mvThCode=1&mvDateTime=" + screeningData[index].mvDate.replace(/-/g, "") + screeningData[index].mvTime.replace(":", "") 
	 + "&mvScreen=" + screeningData[index].mvScreen;

	let form = document.createElement("form");
	form.action = "Step4?" + formData;
	form.method = "post";
	document.body.appendChild(form);
	form.submit();
}
</script>
</html>
