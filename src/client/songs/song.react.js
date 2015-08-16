import './song.styl';
import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import Loading from '../components/loading.react';
import NotFound from '../components/notfound.react';
import React from 'react';
import escape from 'escape-html';
import listenSong from '../firebase/listensong';
import {Link} from 'react-router';

const MAX_FONT_SIZE = 50;
const MIN_READABLE_FONT_SIZE = 8;

@listenSong
export default class Song extends Component {

  static propTypes = {
    msg: React.PropTypes.object.isRequired,
    params: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired
  }

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
    if (!songEl || !this.lyricsEL) return;

    const songElSize = this.getElSize(songEl);
    let fontSize = MIN_READABLE_FONT_SIZE;
    songEl.style.visibility = 'hidden';

    while (fontSize !== MAX_FONT_SIZE) {
      this.lyricsEL.style.fontSize = fontSize + 'px';
      const articleElSize = this.getElSize(this.lyricsEL);
      // It seems that measuring only width is the best pattern.
      if (articleElSize.width > songElSize.width) {
        this.lyricsEL.style.fontSize = (fontSize - 1) + 'px';
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
    const {msg, params: {id}, songs: {map}} = this.props;
    const song = map.get(id);

    if (song === null) return <NotFound msg={msg} />;
    if (!song) return <Loading msg={msg} />;

    const title = song.name + ' / ' + song.artist;
    const displayLyrics = this.getDisplayLyrics(song.lyrics);

    return (
      <DocumentTitle title={title}>
        <div className="song">
          <nav>
            <Link to="songs">{msg.app.header.songs}</Link>
            <Link params={{id}} to="songs-edit">{msg.app.buttons.edit}</Link>
          </nav>
          <h1>{title}</h1>
          <div
            className="lyrics"
            dangerouslySetInnerHTML={{__html: displayLyrics}}
            ref={c => this.lyricsEL = React.findDOMNode(c)}
          />
        </div>
      </DocumentTitle>
    );
  }

}
