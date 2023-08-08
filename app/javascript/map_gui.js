function showMessage(text) {
  document.getElementById("message-text").innerHTML = text;
  document.getElementById("message-container").classList.remove("hidden");
  setTimeout(hideMessage, 3000);
}

function hideMessage() {
  document.getElementById("message-container").classList.add("hidden");
}

function getPlayerTurn(players, turn) {
  // Use the remainder operator to ensure that the turn loops back to the beginning of the players array
  var index = turn % players.length;
  
  // Return the player whose turn it is
  return players[index];
}