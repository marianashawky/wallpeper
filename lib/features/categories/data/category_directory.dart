import '../../../core/constants/app_info.dart';
import '../domain/wallpaper_category.dart';

/// Add a category by appending to this list. Screens read it from the repository.
const List<WallpaperCategory> categoryDirectory = [
  WallpaperCategory(
    id: CategoryIds.live,
    name: 'Live',
    coverUrl: 'https://images.unsplash.com/photo-1505118380757-91f5f5632de0?auto=format&fit=crop&w=800&h=1000&q=75',
    filters: [
      CategoryFilter(tag: 'rain', label: 'Rain'),
      CategoryFilter(tag: 'waterfall', label: 'Waterfalls'),
      CategoryFilter(tag: 'ocean', label: 'Ocean'),
      CategoryFilter(tag: 'clouds', label: 'Clouds'),
      CategoryFilter(tag: 'stars', label: 'Stars'),
      CategoryFilter(tag: 'forest', label: 'Forest'),
      CategoryFilter(tag: 'fire', label: 'Fire'),
      CategoryFilter(tag: 'snow', label: 'Snow'),
      CategoryFilter(tag: 'sunset', label: 'Sunset'),
    ],
  ),
  WallpaperCategory(
    id: CategoryIds.anime,
    name: 'Anime',
    coverUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=800&h=1000&q=75',
    filters: [
      CategoryFilter(tag: 'character', label: 'Characters'),
      CategoryFilter(tag: 'dark', label: 'Dark'),
      CategoryFilter(tag: 'cinematic', label: 'Cinematic'),
      CategoryFilter(tag: 'action', label: 'Action'),
      CategoryFilter(tag: 'minimal', label: 'Minimal'),
      CategoryFilter(tag: 'couple', label: 'Couple'),
      CategoryFilter(tag: 'fantasy', label: 'Fantasy'),
    ],
  ),
  WallpaperCategory(
    id: CategoryIds.nature,
    name: 'Nature',
    coverUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&h=1000&q=75',
    filters: [
      CategoryFilter(tag: 'mountains', label: 'Mountains'),
      CategoryFilter(tag: 'beach', label: 'Beaches'),
      CategoryFilter(tag: 'forest', label: 'Forests'),
      CategoryFilter(tag: 'waterfall', label: 'Waterfalls'),
      CategoryFilter(tag: 'sunset', label: 'Sunsets'),
      CategoryFilter(tag: 'rain', label: 'Rain'),
      CategoryFilter(tag: 'sky', label: 'Sky'),
      CategoryFilter(tag: 'flowers', label: 'Flowers'),
      CategoryFilter(tag: 'animals', label: 'Animals'),
      CategoryFilter(tag: 'ocean', label: 'Ocean'),
      CategoryFilter(tag: 'clouds', label: 'Clouds'),
      CategoryFilter(tag: 'stars', label: 'Stars'),
      CategoryFilter(tag: 'fire', label: 'Fire'),
      CategoryFilter(tag: 'snow', label: 'Snow'),
    ],
  ),
  WallpaperCategory(
    id: CategoryIds.cars,
    name: 'Cars',
    coverUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&h=1000&q=75',
    filters: [],
  ),
  WallpaperCategory(
    id: CategoryIds.gaming,
    name: 'Gaming',
    coverUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&h=1000&q=75',
    filters: [],
  ),
  WallpaperCategory(
    id: CategoryIds.space,
    name: 'Space',
    coverUrl: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?auto=format&fit=crop&w=800&h=1000&q=75',
    filters: [],
  ),
  WallpaperCategory(
    id: CategoryIds.abstract,
    name: 'Abstract',
    coverUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=800&h=1000&q=75',
    filters: [],
  ),
  WallpaperCategory(
    id: CategoryIds.minimal,
    name: 'Minimal',
    coverUrl: 'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?auto=format&fit=crop&w=800&h=1000&q=75',
    filters: [],
  ),
  WallpaperCategory(
    id: CategoryIds.technology,
    name: 'Technology',
    coverUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&h=1000&q=75',
    filters: [],
  ),
  WallpaperCategory(
    id: CategoryIds.dark,
    name: 'Dark',
    coverUrl: 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?auto=format&fit=crop&w=800&h=1000&q=75',
    filters: [],
  ),
];
