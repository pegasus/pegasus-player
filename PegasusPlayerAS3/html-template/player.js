var flashObj = document.getElementById('PegasusPlayer');
swfobject.addDomLoadEvent(setPlayer)

function setPlayer()
{
	flashObj = document.getElementById('PegasusPlayer');
	setSongStatus("ready to play music!")
}

function registerEvents()
{
	flashObj.fl_register_event("songPlay", "handleSongPlay");
	flashObj.fl_register_event("songComplete", "handleSongComplete");
}

function songPosition(currentPosition, totalLength) {
    window.document.title=currentPosition+'/'+totalLength;
	var currentTime = document.getElementById("currentTime")
	currentTime.innerHTML = currentPosition+'/'+totalLength;
}

function pauseSong()
{
	flashObj.fl_pause_mp3();
	setSongStatus("paused...");
}

function playSong()
{
	flashObj.fl_play_mp3();
	setSongStatus("playing...");
}

function getStatus()
{
	var statusSpan = document.getElementById("statusText");
	var status = flashObj.fl_get_status();

	statusSpan.innerHTML = status.mp3URL
}

function flashReady(player_id)
{
	flashObj = document.getElementById('fl_music_player');
	registerEvents()
	setSongStatus(player_id + " is ready...");
}

function handleSongComplete(url, position, opaque)
{
	setSongStatus("complete...");
}

function handleSongPlay(url, position, opaque)
{
	var statusSpan = document.getElementById("statusText");
	statusSpan.innerHTML = url
	setSongStatus("playing...");
}

function skipToPercent(percent)
{
	flashObj.fl_jump_song_position(percent);
}

function adjustVolume(value)
{
	flashObj.fl_volume_mp3(value);
}

function stopSong()
{
	flashObj.fl_stop_mp3();
	setSongStatus("stopped...");
}

function setSongStatus(status)
{
	var songStatus = document.getElementById("songStatus");
	songStatus.innerHTML = status;
}

function updateID3(id3)
{
	var artistText = document.getElementById("artistText");
	var albumText = document.getElementById("albumText");
	var songText = document.getElementById("songText");
    
	artistText.innerHTML = id3.artist;
	albumText.innerHTML = id3.album;
	songText.innerHTML = id3.songName;

	getStatus()
}

function loadSong(url)
{
	flashObj.fl_load_mp3(url);
	var statusSpan = document.getElementById("statusText");

	statusSpan.innerHTML = "nothing is playing..."
	setSongStatus("stopped...");
}