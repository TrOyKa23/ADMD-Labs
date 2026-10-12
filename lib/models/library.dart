import 'book.dart';
import 'library_item.dart';
import 'magazine.dart';
import 'user.dart';

class Library {
final List<LibraryItem> _items = [];

List<LibraryItem> get items =>
List.unmodifiable(_items);

bool addItem(LibraryItem item) {
if (item.title.trim().isEmpty) {
return false;
}

final duplicate = _items.any(
  (existing) =>
      existing.title.toLowerCase() ==
          item.title.toLowerCase() &&
      existing.runtimeType == item.runtimeType,
);

if (duplicate) {
  return false;
}

_items.add(item);
return true;


}

List<LibraryItem> searchByTitle(String? query) {
if (query == null || query.trim().isEmpty) {
return [];
}


final normalized = query.trim().toLowerCase();

return _items
    .where((item) =>
        item.title.toLowerCase().contains(normalized))
    .toList();


}

List<LibraryItem> getItemsByAuthor(String? author) {
if (author == null || author.trim().isEmpty) {
return [];
}


final normalized = author.trim().toLowerCase();

return _items
    .where((item) =>
        item.author?.toLowerCase() == normalized)
    .toList();


}

List<LibraryItem> getRecentItems({
int withinDays = 365,
}) {
final cutoff = DateTime.now().subtract(
Duration(days: withinDays),
);

return _items
    .where((item) =>
        item.publishDate != null &&
        !item.publishDate!.isBefore(cutoff) &&
        !item.publishDate!.isAfter(DateTime.now()))
    .toList();


}

bool borrowItem(
LibraryItem item,
User borrower,
DateTime dueDate,
) {
if (!_items.contains(item) ||
item.isBorrowed ||
!dueDate.isAfter(DateTime.now())) {
return false;
}


item.borrower = borrower;
item.dueDate = dueDate;
return true;


}

bool returnItem(LibraryItem item) {
if (!_items.contains(item) || !item.isBorrowed) {
return false;
}


item.borrower = null;
item.dueDate = null;
return true;


}
}
