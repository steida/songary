import './song.styl';
import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import React from 'react';
import escape from 'escape-html';
import listenFirebase from '../firebase/listenfirebase';

@listenFirebase((props, firebase) => ({
  action: props.actions.songs.onSong,
  ref: firebase
    .child('songs')
    .child(props.params.id)
}))
export default class Song extends Component {

  static propTypes = {
    params: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired
  }

  static MAX_FONT_SIZE = 50;
  static MIN_READABLE_FONT_SIZE = 8;

  constructor(props) {
    super(props);
    this.onWindowResize = ::this.onWindowResize;
  }

  getDisplayLyrics(lyrics) {
    return escape(lyrics)
      .replace(/\[([^\]]+)\]/g, (str, chord) => `<sup>${chord}</sup>`);
  }

  componentDidMount() {
    this.setLyricsMaxFontSize();
    window.addEventListener('resize', this.onWindowResize);
  }

  componentDidUpdate() {
    this.setLyricsMaxFontSize();
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.onWindowResize);
  }

  // Detect max lyrics fontSize to fit into screen.
  setLyricsMaxFontSize() {
    const songEl = React.findDOMNode(this);
    // Because it's called in timeout, so element can be gone.
    if (!songEl) return;
    const lyricsEl = React.findDOMNode(this.refs.lyrics);
    const songElSize = this.getElSize(songEl);
    let fontSize = Song.MIN_READABLE_FONT_SIZE;
    songEl.style.visibility = 'hidden';
    while (fontSize !== Song.MAX_FONT_SIZE) {
      lyricsEl.style.fontSize = fontSize + 'px';
      const articleElSize = this.getElSize(lyricsEl);
      // It seems that measuring only width is the best pattern.
      if (articleElSize.width > songElSize.width) {
        lyricsEl.style.fontSize = (fontSize - 1) + 'px';
        break;
      }
      fontSize++;
    }
    songEl.style.visibility = '';
  }

  getElSize(el) {
    return {width: el.offsetWidth, height: el.offsetHeight};
  }

  onWindowResize() {
    clearTimeout(this.resizeTimer);
    this.resizeTimer = setTimeout(() => {
      this.setLyricsMaxFontSize();
    }, 100);
  }

  render() {
    const {params: {id}, songs: {map}} = this.props;
    const song = map.get(id);

    // TODO: Distinguish 404 from not yet loaded.
    if (!song) return null;

    const title = song.name + ' / ' + song.artist;
    const displayLyrics = this.getDisplayLyrics(song.lyrics);

    return (
      <DocumentTitle title={title}>
        <div className="song">
          <h1>{title}</h1>
          <div
            className="lyrics"
            dangerouslySetInnerHTML={{__html: displayLyrics}}
            ref="lyrics"
          />
        </div>
      </DocumentTitle>
    );
  }

}
