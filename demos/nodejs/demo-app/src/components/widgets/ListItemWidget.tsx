import React from 'react';
import {
  ListItem,
  IconButton,
  ListItemIcon,
  ListItemText,
  ListItemButton
} from '@mui/material';

import DeleteIcon from '@mui/icons-material/Delete';
import FolderIcon from '@mui/icons-material/Folder';
import ImageIcon from '@mui/icons-material/Image';

export type ListItemWidgetProps = {
  title: string;
  description?: string;
  image?: string;
  selected?: boolean;
  onPress?: () => void;
  onDelete?: () => void;
};

export function ListItemWidget(props: ListItemWidgetProps) {
  return (
    <ListItem
      secondaryAction={
        props.onDelete && (
          <IconButton edge="end" aria-label="delete" onClick={props.onDelete}>
            <DeleteIcon />
          </IconButton>
        )
      }
      disablePadding>
      <ListItemButton selected={props.selected} onClick={props.onPress}>
        <ListItemIcon>
          {props.image ? <ImageIcon /> : <FolderIcon />}
        </ListItemIcon>
        <ListItemText primary={props.title} secondary={props.description} />
      </ListItemButton>
    </ListItem>
  );
}
