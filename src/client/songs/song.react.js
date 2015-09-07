import './song.styl';
import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import Loading from '../components/loading.react';
import NotFound from '../components/notfound.react';
import React from 'react';
import Star from './star.react';
import escape from 'escape-html';
import listenSong from './listensong';
import {Link} from 'react-router';

// 26 seems to be the best for tablet.
const MAX_FONT_SIZE = 26;
const MIN_READABLE_FONT_SIZE = 8;

@listenSong
export default class Song extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    params: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired,
    users: React.PropTypes.object.isRequired
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
    if (!songEl || !this.lyricsEl) return;
    const songElWidth = songEl.offsetWidth;
    let fontSize = MIN_READABLE_FONT_SIZE;
    songEl.style.visibility = 'hidden';
    while (fontSize !== MAX_FONT_SIZE) {
      this.lyricsEl.style.fontSize = fontSize + 'px';
      // It seems that measuring only width is the best pattern.
      if (this.lyricsEl.offsetWidth > songElWidth) {
        this.lyricsEl.style.fontSize = (fontSize - 1) + 'px';
        break;
      }
      fontSize++;
    }
    songEl.style.visibility = '';
  }

  onWindowResize() {
    clearTimeout(this.resizeTimer);
    this.resizeTimer = setTimeout(() => {
      this.setLyricsMaxFontSize();
    }, 100);
  }

  render() {
    const {
      actions,
      msg,
      params: {id},
      songs: {map, starred},
      users: {viewer}
    } = this.props;
    const song = map.get(id);

    if (song === null) return <NotFound msg={msg} />;
    if (!song) return <Loading msg={msg} />;

    const displayLyrics = this.getDisplayLyrics(song.lyrics);
    const viewerIsSongCreator = viewer && viewer.id === song.createdBy;
    const star =
      viewer &&
      !viewerIsSongCreator &&
      <Star
        checked={starred.hasIn([viewer.id, song.id])}
        {...{actions, song, viewer}}
      />;
    const songElementId = `song${song.id}`;
    const lyricsElementId = `lyrics${song.id}`;

    return (
      <DocumentTitle title={song.name + ' / ' + song.artist}>
        <div className="song" id={songElementId}>
          <nav>
            <Link to="songs">{msg.app.header.songs}</Link>
            <Link to="my-songs">{msg.app.header.mySongs}</Link>
            {viewerIsSongCreator &&
              <Link params={{id}} to="songs-edit">{msg.app.button.edit}</Link>
            }
          </nav>
          <h1>
            <span>{song.name}</span>&nbsp;/&nbsp;
            <span>{song.artist}</span>&nbsp;
            <span>{star}</span>
          </h1>
          <div
            className="lyrics"
            dangerouslySetInnerHTML={{__html: displayLyrics}}
            id={lyricsElementId}
            ref={c => this.lyricsEl = React.findDOMNode(c)}
          />
          <script
            // MaxFontSize code must be called asap to prevent FOUC when song
            // is loaded and rendered on server side. It works for server render
            // only - https://github.com/facebook/react/issues/4801
            // Original code to be packed.
            // (function(songEl, lyricsEl, fontSize, maxFontSize) {
            //   var songElWidth = songEl.offsetWidth;
            //   songEl.style.visibility = 'hidden';
            //   while (fontSize !== maxFontSize) {
            //     lyricsEl.style.fontSize = fontSize + 'px';
            //     // It seems that measuring only width is the best pattern.
            //     if (lyricsEl.offsetWidth > songElWidth) {
            //       lyricsEl.style.fontSize = (fontSize - 1) + 'px';
            //       break;
            //     }
            //     fontSize++;
            //   }
            //   songEl.style.visibility = '';
            // })(
            //   document.getElementById('${songElementId}'),
            //   document.getElementById('${lyricsElementId}'),
            //   ${MIN_READABLE_FONT_SIZE},
            //   ${MAX_FONT_SIZE}
            // );
            dangerouslySetInnerHTML={{__html: `(function(b,c,a,d){var e=b.offsetWidth;for(b.style.visibility="hidden";a!==d;){c.style.fontSize=a+"px";if(c.offsetWidth>e){c.style.fontSize=a-1+"px";break}a++}b.style.visibility=""})(document.getElementById('${songElementId}'),document.getElementById('${lyricsElementId}'),${MIN_READABLE_FONT_SIZE},${MAX_FONT_SIZE});`}}
          />
        </div>
      </DocumentTitle>
    );
  }

}
