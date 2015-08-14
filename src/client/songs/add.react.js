import './add.styl';
import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import React from 'react';
import Textarea from 'react-textarea-autosize';
import requireAuth from '../auth/requireauth.react';
import {FormattedHTMLMessage} from 'react-intl';
import {focusInvalidField} from '../lib/validation';

@requireAuth
export default class Add extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired,
    users: React.PropTypes.object.isRequired
  }

  onFormSubmit(e) {
    e.preventDefault();
    const {
      actions: {songs: actions},
      songs: {add: song},
      users: {viewer}
    } = this.props;
    actions
      .add(song, viewer)
      .catch(focusInvalidField(this));
  }

  onLyricsPaste(e) {
    this.tryExtractChordsFromPastedLyrics(e);
  }

  tryExtractChordsFromPastedLyrics(e) {
    const {actions: {songs: actions}} = this.props;
    const html = e.clipboardData.getData('text/html');
    if (!html) return;

    e.preventDefault();
    const value = this.extractChordsFromPastedLyrics(html);
    actions.setAddSongField({
      target: {name: 'lyrics', value}
    });
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
    const {
      actions: {songs: actions},
      msg: {songs: {add: msg}},
      songs: {add: song}
    } = this.props;

    return (
      <DocumentTitle title={msg.title}>
        <div className="songs-add">
          <form onSubmit={::this.onFormSubmit}>
            <input
              autoFocus
              name="name"
              onChange={actions.setAddSongField}
              placeholder="song name"
              value={song.name}
            />
            <input
              name="artist"
              onChange={actions.setAddSongField}
              placeholder="artist"
              value={song.artist}
            />
            <Textarea
              minRows={6}
              name="lyrics"
              onChange={actions.setAddSongField}
              onPaste={::this.onLyricsPaste}
              placeholder={msg.placeholder}
              ref="lyrics"
              value={song.lyrics}
            />
            <p>
              <FormattedHTMLMessage message={msg.lyricsHelp} />
            </p>
            <div>
              <button>{msg.button}</button>
            </div>
          </form>
        </div>
      </DocumentTitle>
    );
  }

}
