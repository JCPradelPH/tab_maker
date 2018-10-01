
class TabManagementData{
  String currentWorkingTabId, currentWorkingTabName;
  int currentWorkingTabIndex;

  void setCurrentWorkingTabId(currentWorkingTabId) => this.currentWorkingTabId = currentWorkingTabId;
  void setCurrentWorkingTabName(currentWorkingTabName) => this.currentWorkingTabName = currentWorkingTabName;
  void setCurrentWorkingTabIndex(currentWorkingTabIndex) => this.currentWorkingTabIndex = currentWorkingTabIndex;

  String get getCurrentWorkingTabId => this.currentWorkingTabId;
  String get getCurrentWorkingTabName => this.currentWorkingTabName;
  int get getCurrentWorkingTabIndex => this.currentWorkingTabIndex;

  TabManagementData({
    this.currentWorkingTabId,
    this.currentWorkingTabName,
    this.currentWorkingTabIndex,
  });
}