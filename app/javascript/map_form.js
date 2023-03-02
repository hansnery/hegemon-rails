var select = document.querySelector('select#map_max_players');

select.addEventListener('change', () => {
  const url = select.dataset.url;
  const numPlayers = select.value;

  const playersForm = document.querySelector('#players-form');

  while (playersForm.firstChild) {
    playersForm.removeChild(playersForm.firstChild);
  }

  function printForm(numPlayers) {
    for (let i = 1; i <= numPlayers; i++) {
      const formHTML = `<div>
                          <label for="player_${i}">Player ${i}:</label>
                          <input type="text" name="player_${i}" id="player_${i}" required>
                        </div>`
      playersForm.insertAdjacentHTML('beforeend', formHTML);
      playersForm.style.display = 'block';
    }
  }

  playersForm.innerHTML = "";

  if (numPlayers > 2) {
    printForm(numPlayers);
  } else {
    printForm(2);
  }
});
