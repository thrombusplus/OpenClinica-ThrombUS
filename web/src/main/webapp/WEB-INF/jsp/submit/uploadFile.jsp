<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean scope='session' id='pageMessage' class='java.lang.String'/>
<jsp:useBean scope='session' id='mayProcessUploading' class='java.lang.String'/>
<jsp:useBean scope='request' id='fileItemId' class='java.lang.String'/>
<jsp:useBean scope='request' id='fileName' class='java.lang.String'/>
<jsp:useBean scope='request' id='inputName' class='java.lang.String'/>
<jsp:useBean scope='request' id='attachedFilePath' class='java.lang.String'/>
<jsp:useBean scope='request' id='uploadFileStatus' class='java.lang.String'/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.notes" var="restext"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.workflow" var="resworkflow"/>

<link rel="stylesheet" href="includes/styles.css" type="text/css">

<html>
<script src="includes/jmesa/jquery.min.js"></script>
		<style>
			.frame {
				position: absolute;
				top: -9999px;
				left: -9999px;
			}
			.progress-bar {
			    position:absolute;
			    width: 100%;
				height: 20px;
				display: none;
				border: 2px solid green;
			}
			.progress {
				background-color: blue;
				height: 100%;
				width: 0px;
			}
		</style>
<script>
	var progress;
	
	function upload() {
		// avoid concurrent processing
		if (progress) return;
		var upform = document.getElementById('uploadForm'), time = new Date().getTime();
		if(checkForm(upform)){
			upform.action = 'UploadFile?time=' + time;
			upform.submit();
			startProgressbar(time);
		}
	}
	
	function processUpload(itemId,fileName,isGroupItem) {
		var a = fileName;
		var b = 'ft' + itemId;
		var c = 'input' + itemId;
		if(isGroupItem == 'true' && itemId.indexOf("input") > 0 ) {
			c = itemId;
		}
		var bb = window.opener.document.getElementById('ft'+itemId);
		bb.setAttribute("value", a);
		window.opener.document.crfForm.elements[b].value = a;
		window.opener.document.crfForm.elements[c].value = a;
	}

	function cleanFile() {
		var f = document.getElementById("file");
		f.value = "";
		window.close();
	}
	
	function checkForm(form) {
    var file_name = form.elements['file'].value;
        if(file_name==''){
	        alert ("Select a file to upload!");
	        return false;
	    }
	 return true;
     }
     
     function startProgressbar(startTime) {
				// display progress bar
				$('.progress-bar').css('display', 'block');
				// start timer
				progress = setInterval(function () {
					// ask progress
					$.ajax({
						type: "GET",
						url: "UploadFile",
						data: {time: startTime},
						success: function (data, textStatus,jqXHR ) {
							// get progress from response data
							var d = eval('(' + data + ')'),
								uploadprogress = parseInt(d.progress[startTime]);
							// change progress width
							$('.progress').css('width', uploadprogress+'%');
							if (uploadprogress == 100) { // upload finished
								// stop timer
								clearInterval(progress);
								setTimeout(function () {
									// hide progress bar
									$('.progress-bar').css('display', '');
									$('.progress').css('width', '');
									// clear timer variable
									progress = null;
								}, 1000);
							}
						}
					})
				}, 1000);
			}

</script>

<body>
<br><br><br>
	<div style="position:absolute;  left:20px; width: 600px;">
<c:forEach var="message" items="${pageMessages}">
 <c:out value="${message}" escapeXml="false"/>
</c:forEach>
</div>
<br><br><br>
<form id="uploadForm" name="uploadForm" method="post" enctype="multipart/form-data">
	<input type="hidden" name="itemId" value="${fn:escapeXml(fileItemId)}">
	<input type="hidden" name="inputName" value="${fn:escapeXml(inputName)}">
		<div style="position:absolute;  left:20px; width: 600px;">
	<c:choose>
	<c:when test="${mayProcessUploading=='true'}">
		<c:choose>
		<c:when test="${uploadFileStatus=='successed'}">
			<c:choose>
			<c:when test="${inputName == null || inputName == ''}">
				<script type="text/javascript">
					processUpload('<c:out value="${fileItemId}"/>','<c:out value="${fileName}"/>','false');
				</script>
			</c:when>
			<c:otherwise>
				<script type="text/javascript">
					processUpload('<c:out value="${inputName}"/>','<c:out value="${fileName}"/>','true');
				</script>
			</c:otherwise>
			</c:choose>
			<br><br>
			<fmt:message key="select_close_window_button" bundle="${restext}"/>
			<br><br><br>
			<P><input type="button" name="close" value="<fmt:message key="close_window" bundle="${resword}"/>" onClick="javascript:window.close();" class="button_long"></P>
		</c:when>
		<c:otherwise>
			<fmt:message key="upload_note" bundle="${restext}"/>
			<br><br>
			<fmt:message key="select_cancel_upload_button" bundle="${restext}"/>
			<br><br><br>
			<input id="file" type="file" name="browse" size="150">
			<br><br>
			<!-- progress bar -->
			<div class="progress-bar">
				<div class="progress"></div>
			</div>
			<br><br>
			<P><input type="button" onclick="upload()" value="<fmt:message key="upload_file" bundle="${resword}"/>" class="button_long">
			<input type="button" name="cancel" value="<fmt:message key="cancel_upload" bundle="${resword}"/>" onClick="cleanFile()" class="button_long"></P>
			<input type="hidden" name="crfId" value="<c:out value="${version.crfId}"/>">
		</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<fmt:message key="uploading_not_process_because_permission" bundle="${restext}"/>
	</c:otherwise>
	</c:choose>
	</div>
</form>

</body>
</html>