import './songform.styl';
import Component from '../components/component.react';
import React from 'react';
import Textarea from 'react-textarea-autosize';
import {FormattedHTMLMessage} from 'react-intl';
import {focusInvalidField} from '../lib/validation';

export default class Add extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    editMode: React.PropTypes.bool,
    editedSong: React.PropTypes.object,
    isEdit: React.PropTypes.bool,
    msg: React.PropTypes.object.isRequired,
    song: React.PropTypes.object.isRequired
  }

  onFormSubmit(e) {
    e.preventDefault();
    const {actions, editMode} = this.props;
    const song = this.getSong();
    const promise = editMode
      ? actions.save(song)
      : actions.add(song);
    promise.catch(focusInvalidField(this));
  }

  onLyricsPaste(e) {
    this.tryExtractChordsFromPastedLyrics(e);
  }

  // Why at this place? Because "declare then use" order.
  getSong() {
    const {song, editedSong} = this.props;
    return editedSong || song;
  }

  tryExtractChordsFromPastedLyrics(e) {
    const {actions} = this.props;
    const song = this.getSong();
    const html = e.clipboardData.getData('text/html');
    if (!html) return;

    e.preventDefault();
    const value = this.extractChordsFromPastedLyrics(html);
    actions.setSongField(song, {name: 'lyrics', value});
  }

  extractChordsFromPastedLyrics(html) {
    const el = document.createElement('div');
    el.innerHTML = html;

    // Convert sup elements to chords. Used by supermusic.sk for example.
    [].slice.call(el.querySelectorAll('sup')).forEach(sup => {
      const chord = sup.textContent;
      const textNode = document.createTextNode(`[${chord}]`);
      sup.parentNode.replaceChild(textNode, sup);
    });

    // Preserve new lines.
    [].slice.call(el.querySelectorAll('br')).forEach(br => {
      const newLine = document.createTextNode('\n');
      br.parentNode.replaceChild(newLine, br);
    });

    return el.textContent.trim();
  }

  render() {
    const {actions, editMode, msg} = this.props;
    const song = this.getSong();
    const onChange = e => actions.setSongField(song, e.target);

    return (
      <form className="songs-form" onSubmit={::this.onFormSubmit}>
        <input
          autoFocus
          name="name"
          onChange={onChange}
          placeholder="song name"
          value={song.name}
        />
        <input
          name="artist"
          onChange={onChange}
          placeholder="artist"
          value={song.artist}
        />
        <Textarea
          minRows={6}
          name="lyrics"
          onChange={onChange}
          onPaste={::this.onLyricsPaste}
          placeholder={msg.songs.form.placeholder}
          value={song.lyrics}
        />
        <p>
          <FormattedHTMLMessage message={msg.songs.form.lyricsHelp} />
        </p>
        <div>
          <button>{
            editMode ? msg.app.buttons.save : msg.app.buttons.add
          }</button>
        </div>
      </form>
    );
  }

}
