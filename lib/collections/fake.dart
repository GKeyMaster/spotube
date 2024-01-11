import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/track.dart';

abstract class FakeData {
  static final Image image = Image()
    ..height = 1
    ..width = 1
    ..url = "url";

  static final Followers followers = Followers()
    ..href = "text"
    ..total = 1;

  static final Artist artist = Artist()
    ..id = "1"
    ..name = "Wow artist Good!"
    ..images = [image]
    ..popularity = 1
    ..type = "type"
    ..uri = "uri"
    ..externalUrls = externalUrls
    ..genres = ["genre"]
    ..href = "text"
    ..followers = followers;

  static final externalIds = ExternalIds()
    ..isrc = "text"
    ..ean = "text"
    ..upc = "text";

  static final externalUrls = ExternalUrls()..spotify = "text";

  static final Album album = Album()
    ..id = "1"
    ..genres = ["genre"]
    ..label = "label"
    ..popularity = 1
    ..albumType = AlbumType.album
    ..artists = [artist]
    ..availableMarkets = [Market.BD]
    ..externalUrls = externalUrls
    ..href = "text"
    ..images = [image]
    ..name = "Another good album"
    ..releaseDate = "2021-01-01"
    ..releaseDatePrecision = DatePrecision.day
    ..tracks = [track]
    ..type = "type"
    ..uri = "uri"
    ..externalIds = externalIds
    ..copyrights = [
      Copyright()
        ..type = CopyrightType.C
        ..text = "text",
    ];

  static final ArtistSimple artistSimple = ArtistSimple()
    ..id = "1"
    ..name = "What an artist"
    ..type = "type"
    ..uri = "uri"
    ..externalUrls = externalUrls;

  static final AlbumSimple albumSimple = AlbumSimple()
    ..id = "1"
    ..albumType = AlbumType.album
    ..artists = [artistSimple]
    ..availableMarkets = [Market.BD]
    ..externalUrls = externalUrls
    ..href = "text"
    ..images = [image]
    ..name = "A good album"
    ..releaseDate = "2021-01-01"
    ..releaseDatePrecision = DatePrecision.day
    ..type = "type"
    ..uri = "uri";

  static final Track track = Track()
    ..id = "1"
    ..artists = [artist, artist, artist]
    ..album = albumSimple
    ..availableMarkets = [Market.BD]
    ..discNumber = 1
    ..durationMs = 50000
    ..explicit = false
    ..externalUrls = externalUrls
    ..href = "text"
    ..name = "A Track Name"
    ..popularity = 1
    ..previewUrl = "url"
    ..trackNumber = 1
    ..type = "type"
    ..uri = "uri"
    ..isPlayable = true
    ..explicit = false
    ..linkedFrom = trackLink;

  static final TrackLink trackLink = TrackLink()
    ..id = "1"
    ..type = "type"
    ..uri = "uri"
    ..externalUrls = {"spotify": "text"}
    ..href = "text";

  static final Paging<Track> paging = Paging()
    ..href = "text"
    ..itemsNative = [track.toJson()]
    ..limit = 1
    ..next = "text"
    ..offset = 1
    ..previous = "text"
    ..total = 1;

  static final User user = User()
    ..id = "1"
    ..displayName = "Your Name"
    ..birthdate = "2021-01-01"
    ..country = Market.BD
    ..email = "test@email.com"
    ..followers = followers
    ..href = "text"
    ..images = [image]
    ..type = "type"
    ..uri = "uri";

  static final TracksLink tracksLink = TracksLink()
    ..href = "text"
    ..total = 1;

  static final Playlist playlist = Playlist()
    ..id = "1"
    ..collaborative = false
    ..description = "A very good playlist description"
    ..externalUrls = externalUrls
    ..followers = followers
    ..href = "text"
    ..images = [image]
    ..name = "A good playlist"
    ..owner = user
    ..public = true
    ..snapshotId = "text"
    ..tracks = paging
    ..tracksLink = tracksLink
    ..type = "type"
    ..uri = "uri";

  static final PlaylistSimple playlistSimple = PlaylistSimple()
    ..id = "1"
    ..collaborative = false
    ..externalUrls = externalUrls
    ..href = "text"
    ..images = [image]
    ..name = "A good playlist"
    ..owner = user
    ..public = true
    ..snapshotId = "text"
    ..tracksLink = tracksLink
    ..type = "type"
    ..description = "A very good playlist description"
    ..uri = "uri";

  static final Category category = Category()
    ..href = "text"
    ..icons = [image]
    ..id = "1"
    ..name = "category";
}
